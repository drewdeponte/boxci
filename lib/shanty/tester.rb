require "yaml"
require "net/ssh"
require "net/scp"

module Shanty
  class Tester < Thor
    include Thor::Actions

    source_root(File.dirname(__FILE__))

    no_commands do
      def test(options)
        # depencency_checker = Shanty::DependencyChecker.new
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
        create_reports_directory
        upload_test_runner
        run_tests
        # download_test_reports
        say "Finished!", :green
      ensure
        # cleanup
      end

      def initial_config(options)
        @gem_path = File.expand_path(File.dirname(__FILE__) + "/../..")
        @report_location = File.join(Shanty.project_path, "reports")
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

      def create_reports_directory
        say "Creating the reports directory on the box...", :blue if verbose?
        Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
          # TODO: Make this configurable, ex: report_exts = @config['report_file_ext'] || ['xml']
          report_exts = ['xml']
          report_exts.each do |ext|
            ssh.exec!  "mkdir -p /vagrant/reports/#{ext}"
          end
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
        Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
          say "Running the test steps on the box...", :blue if verbose?
          puts ssh.exec! "/vagrant/test_runner.sh"
        end
      end

      def download_test_reports
        Net::SSH.start("default", nil, {:config => File.join(@project_workspace_folder, "ssh-config.local")}) do |ssh|
          empty_directory @report_location, :verbose => verbose?
          # say "Removing old reports...", :blue if verbose?
          Dir["#{@report_location}/*.*"].each { |file| FileUtils.rm(file) }
          say "Downloading the reports...", :blue if verbose?
          ssh.scp.download! "/vagrant/#{@project_uid}/reports/*", @report_location, :recursive => true
        end
      end

      def cleanup
        if @project_workspace_folder && File.directory?(@project_workspace_folder)
          say "Cleaning up...", :blue
          inside @project_workspace_folder do
            run "vagrant destroy", :verbose => verbose?
            remove_dir @project_workspace_folder, :verbose => verbose?
          end
        end
      end
    end
  end
end
