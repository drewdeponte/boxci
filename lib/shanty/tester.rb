require "yaml"
require "net/ssh"
require "net/scp"

module Shanty
  class Tester < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    source_root(File.dirname(__FILE__))

    no_commands do
      def test(options)
        @tester_exit_code = 0
        # depencency_checker = Shanty::DependencyChecker.new
        # depencency_checker.verify_all
        puts "DREW: test: about to run initial_config()"
        initial_config(options)
        puts "DREW: test: ran initial_config()"

        puts "DREW: test: about to create_project_folder()"
        create_project_folder
        puts "DREW: test: ran create_project_folder()"
        puts "DREW: test: about to run create_project_archive()"
        create_project_archive
        puts "DREW: test: ran create_project_archive()"
        puts "DREW: test: about to run write_vagrant_file()"
        write_vagrant_file
        puts "DREW: test: ran write_vagrant_file()"
        puts "DREW: test: about to run write_test_runner()"
        write_test_runner
        puts "DREW: test: ran write_test_runner()"
        puts "DREW: test: checking if the provider requires plugins"
        if @provider_object.requires_plugin?
          puts "DREW: test: the provider DOES require plugins"
          puts "DREW: test: about to run install_vagrant_plugin()"
          install_vagrant_plugin
          puts "DREW: test: ran install_vagrant_plugin()"
          puts "DREW: test: about to run add_provider_box()"
          add_provider_box
          puts "DREW: test: ran add_provider_box()"
        end
        puts "DREW: test: about to run spin_up_box()"
        spin_up_box
        puts "DREW: test: ran spin_up_box()"
        puts "DREW: test: about to run setup_ssh_config()"
        setup_ssh_config
        puts "DREW: test: ran setup_ssh_config()"
        puts "DREW: test: about ti run install_puppet_on_box()"
        install_puppet_on_box
        puts "DREW: test: ran install_puppet_on_box()"
        puts "DREW: test: about to provision_box()"
        provision_box
        puts "DREW: test: ran provision_box()"
        puts "DREW: test: about to create_artifact_directory()"
        create_artifact_directory
        puts "DREW: test: ran create_artifact_directory()"
        puts "DREW: test: about to run upload_test_runner()"
        upload_test_runner
        puts "DREW: test: ran upload_test_runner()"
        puts "DREW: test: about to run run_tests()"
        run_tests
        puts "DREW: test: ran run_tests()"
        puts "DREW: test: about to run dowload_artifacts()"
        download_artifacts
        puts "DREW: test: ran download_artifacts()"
        say "Finished!", :green
      ensure
        cleanup
        exit @tester_exit_code
      end

      def initial_config(options)
        @gem_path = File.expand_path(File.dirname(__FILE__) + "/../..")
        @puppet_path = File.join(Shanty.project_path, "puppet")
        @project_uid = "#{rand(1000..9000)}-#{rand(1000..9000)}-#{rand(1000..9000)}-#{rand(1000..9000)}"
        @project_workspace_folder = File.join(File.expand_path(ENV['HOME']), '.shanty', @project_uid)
        @options = options
        @provider_config = Shanty.provider_config(provider)
        @project_config = Shanty.project_config
        @provider_object = Shanty::ProviderFactory.build(provider)
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
        inside Shanty.project_path do
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
        test_runner = Shanty::TestRunner.new(Shanty::LanguageFactory.build(Shanty.project_config.language))
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
            # ask user if it's ok to install for them
            if yes?("Would you like to install it now?")
              run "vagrant plugin install #{plugin}", :verbose => verbose?
            end
          else # if vagrant plugin is found
            say "Provider plugin #{plugin} found", :green
          end
        end
      end

      def add_provider_box
        dummy_box_url = @provider_object.dummy_box_url
        if dummy_box_url
          if run "curl --output /dev/null --silent --head --fail #{dummy_box_url}"
            say "Using specified VM Box URL", :green
          else
            say "Could not resolve the Box URL: #{dummy_box_url}", :red
          end
        else
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
          run "vagrant up --no-provision --provider #{provider}", :verbose => verbose?
        end
      end

      def setup_ssh_config
        inside @project_workspace_folder do
          run "vagrant ssh-config > ssh-config.local", :verbose => verbose?
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
          puts ssh.exec! "cd #{@project_config.artifact_path} && tar cf /tmp/shanty_artifacts.tar ."
          ssh.scp.download! "/tmp/shanty_artifacts.tar", '.'
        end
      end

      def cleanup
        if @project_workspace_folder && File.directory?(@project_workspace_folder)
          say "Cleaning up...", :blue
          inside @project_workspace_folder do
            # TODO: figure out option so vagrant destroy doesn't prompt to
            # destroy
            run "vagrant destroy -f", :verbose => verbose?
            remove_dir @project_workspace_folder, :verbose => verbose?
          end
        end
      end
    end
  end
end
