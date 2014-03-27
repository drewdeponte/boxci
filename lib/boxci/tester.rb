require "yaml"
require "net/ssh"
require "net/scp"

module Boxci
  class Tester
    include Thor::Base
    include Thor::Actions

    source_root(File.dirname(__FILE__))

    def test(options)
      File.open('/tmp/boxci.log', 'w') do |f|
        f.write('')
      end

      # NOTE: The Signal.trap('SIGTERM') is required for Bamboo's "Stop
      # Build" functionality because Bamboo basically sends a SIGTERM to
      # Boxci and then immediately closes its stdout and stderr pipes
      # before Boxci has had a chance to cleanup. Therefore, it causes
      # Errno::EPIPE exceptions to be raised. It does seem that in general
      # the use of SIGTERM is correct however one would hope that stdout and
      # stderr pipes would stay open until Boxci exits, but sadly they
      # do not.
      Signal.trap('SIGTERM') do
        File.open('/tmp/boxci.log', 'a+') { |f| f.write("Got SIGTERM, going to cleanup...\n") }

        begin
          cleanup
        rescue Errno::EPIPE => e
          File.open('/tmp/boxci.log', 'a+') { |f| f.write("SIGTERM handler swallowed Errno::EPIPE exception\n") }
        rescue => e
          File.open('/tmp/boxci.log', 'a+') do |f|
            f.write("SIGTERM handler caught exception")
            f.write("#{e.class}\n")
            f.write("#{e.message}\n")
            f.write("#{e.backtrace.join("\n")}\n")
          end
          raise e
        end

        File.open('/tmp/boxci.log', 'a+') { |f| f.write("Finished cleanup process from SIGTERM\n") }
        exit 255
      end

      Signal.trap('SIGINT') do
        cleanup
        exit 255
      end

      # TODO: I don't believe this is necessary as I think Ruby's default
      # handler for SIGPIPE is to ignore it. I need to test this though to
      # verify.
      Signal.trap('SIGPIPE', 'SIG_IGN')

      begin
        @tester_exit_code = 0
        # depencency_checker = Boxci::DependencyChecker.new
        # depencency_checker.verify_all
        initial_config(options)

        create_project_folder
        create_project_archive
        write_vagrant_file
        write_test_runner
        if @provider_object.requires_plugin?
          install_vagrant_plugin
          add_provider_box
        end
        spin_up_box
        setup_ssh_config
        install_puppet_on_box
        provision_box
        create_artifact_directory
        upload_test_runner
        run_tests
        download_artifacts
        say "Finished!", :green
      rescue Errno::EPIPE => e
        File.open('/tmp/boxci.log', 'a+') do |f|
          f.write("test() method swallowed Errno::EPIPE exception\n")
        end
      ensure
        cleanup
      end

      exit @tester_exit_code
    end

    def initial_config(options)
      @gem_path = File.expand_path(File.dirname(__FILE__) + "/../..")
      @puppet_path = File.join(Boxci.project_path, "puppet")
      @project_uid = "#{rand(1000..9000)}-#{rand(1000..9000)}-#{rand(1000..9000)}-#{rand(1000..9000)}"
      @project_workspace_folder = File.join(File.expand_path(ENV['HOME']), '.boxci', @project_uid)
      @options = options
      @provider_config = Boxci.provider_config(provider)
      @project_config = Boxci.project_config
      @provider_object = Boxci::ProviderFactory.build(provider)
    end

    def provider
      @options["provider"]
    end

    def verbose?
      @options["verbose"] == true
    end

    def create_project_folder
      empty_directory @project_workspace_folder, :verbose => verbose?
    end

    def create_project_archive
      inside Boxci.project_path do
        run "git checkout #{@options["revision"]}", :verbose => verbose?
        run "git submodule update --init", :verbose => verbose?
        run "tar cf #{File.join(@project_workspace_folder, "project.tar")} --exclude .git --exclude \"*.log\" --exclude node_modules .", :verbose => verbose?
      end
    end

    def write_vagrant_file
      erb_template = File.join("templates", "providers", provider, "Vagrantfile.erb")
      destination = File.join(@project_workspace_folder, "Vagrantfile")

      template erb_template, destination, :verbose => verbose?
    end

    def write_test_runner
      destination = File.join(@project_workspace_folder, "test_runner.sh")
      test_runner = Boxci::TestRunner.new(Boxci::LanguageFactory.build(Boxci.project_config.language))
      File.open(destination, 'w+') do |f|
        f.write(test_runner.generate_script)
      end
    end

    def install_vagrant_plugin
      inside @project_workspace_folder do
        plugin = @provider_object.plugin
        # check for vagrant plugin
        if !system("vagrant plugin list | grep -q #{plugin}")
          # if vagrant plugin is missing
          say "You are missing the Vagrant plugin for #{provider}", :yellow
          run "vagrant plugin install #{plugin}", :verbose => verbose?
        else # if vagrant plugin is found
          say "Provider plugin #{plugin} found", :green
        end
      end
    end

    def add_provider_box
      dummy_box_url = @provider_object.dummy_box_url
      if dummy_box_url
        inside @project_workspace_folder do
          # check for box
          if !system("vagrant box list | grep dummy | grep -q \"(#{provider})\"")
            # if box is missing
            say "No box found for #{provider}, installing now...", :blue
            run "vagrant box add dummy #{dummy_box_url}", :verbose => verbose?
          else # if vagrant plugin is found
            say "Provider box found", :green
          end
        end
      end
    end

    def spin_up_box
      inside @project_workspace_folder do
        if verbose?
          if !run "vagrant up --no-provision --provider #{provider}", :verbose => verbose?
            raise Boxci::CommandFailed, "Failed to successfully run vagrant up --no-provision --provider #{provider}"
          end
        else
          if !run "vagrant up --no-provision --provider #{provider}"
            raise Boxci::CommandFailed, "Failed to successfully run vagrant up --no-provision --provider #{provider}"
          end
        end
      end
    end

    def setup_ssh_config
      inside @project_workspace_folder do
        if verbose?
          if !run "vagrant ssh-config > ssh-config.local", :verbose => verbose?
            raise Boxci::CommandFailed, "Failed to successfully run vagrant ssh-config > ssh-config.local"
          end
        else
          if !run "vagrant ssh-config > ssh-config.local"
            raise Boxci::CommandFailed, "Failed to successfully run vagrant ssh-config > ssh-config.local"
          end
        end
      end
    end

    def install_puppet_on_box
      say "Opening SSH tunnel into the box...", :blue if verbose?
      Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
        puppet = ssh.exec! "which puppet"
        unless puppet
          say "Running: sudo apt-get --yes update", :blue if verbose?
          ssh.exec! "sudo apt-get --yes update"
          say "Running: sudo apt-get --yes install puppet", :blue if verbose?
          ssh.exec! "sudo apt-get --yes install puppet"
        end
      end
    end

    def provision_box
      say "Provisioning the box with puppet...", :blue if verbose?
      inside @project_workspace_folder do
        run "vagrant provision", :verbose => verbose?
      end
    end

    def create_artifact_directory
      say "Creating the artifact directory on the box...", :blue if verbose?
      Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
        ssh.exec!  "mkdir -p #{@project_config.artifact_path}"
      end
    end

    def upload_test_runner
      Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
        say "Uploading test_runner.sh to the box...", :blue if verbose?
        ssh.scp.upload! File.join(@project_workspace_folder, "test_runner.sh"), "/vagrant/test_runner.sh"
        say "Running: chmod a+x /vagrant/test_runner.sh", :blue if verbose?
        puts ssh.exec! "chmod a+x /vagrant/test_runner.sh"
      end
    end

    def run_tests
      exit_code = nil
      exit_signal = nil
      Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |session|
        say "Running the test steps on the box...", :blue if verbose?
        session.open_channel do |channel|
          channel.on_data do |ch, data|
            $stdout.write(data)
          end

          channel.on_extended_data do |ch, type, data|
            $stderr.write(data)
          end

          channel.on_request("exit-status") do |ch, data|
            exit_code = data.read_long
            @tester_exit_code = exit_code
          end

          channel.exec "/vagrant/test_runner.sh"
        end
        session.loop
      end
    end

    def download_artifacts
      Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
        say "Downloading the reports...", :blue if verbose?
        puts ssh.exec! "cd #{@project_config.artifact_path} && tar cf /tmp/boxci_artifacts.tar ."
        ssh.scp.download! "/tmp/boxci_artifacts.tar", '.'
      end
    end

    def cleanup
      if @project_workspace_folder && File.directory?(@project_workspace_folder)
        # NOTE: The begin rescue for Errno::EPIPE and the &>>
        # /tmp/boxci.log in the backtick execution ARE required for
        # Bamboo's "Stop Build" functionality because Bamboo basically sends
        # a SIGTERM to Boxci and then immediately closes its stdout and
        # stderr pipes before Boxci has had a chance to cleanup. Therefore,
        # it causes Errno::EPIPE exceptions to be raised.
        begin
          say "Cleaning up...", :blue
        rescue Errno::EPIPE => e
          File.open('/tmp/boxci.log', 'a+') { |f| f.write("Cleaning up...\n") }
        end
        inside @project_workspace_folder do
          `vagrant destroy -f >> /tmp/boxci.log 2>&1`
          # run "vagrant destroy -f", :verbose => verbose?, :capture => true
        end
        `rm -rf #{@project_workspace_folder} >> /tmp/boxci.log 2>&1`
        # remove_dir @project_workspace_folder, :verbose => verbose?, :capture => true
      end
    end
  end
end
