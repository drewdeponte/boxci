require "yaml"
require "net/ssh"
require "net/scp"

module Shanty
  class Tester < Shanty::Base
    attr_accessor :gem_path, :config, :report_location, :project_folder

    PROVIDERS = {
      "openstack" => {
        :plugin => "vagrant-openstack-plugin",
        :dummy_box_url => "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"
      },
      "aws" => {
        :plugin => "vagrant-aws",
        :dummy_box_url => "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      }
    }

    no_commands do
      def test(options)
        depencency_checker = Shanty::DependencyChecker.new
        depencency_checker.verify_all
        initial_setup(options)

        create_project_folder
        create_project_archive
        write_vagrant_file
        write_test_runner
        install_vagrant_plugin
        add_provider_box
        spin_up_box
        setup_ssh_config
        install_puppet_on_box
        provision_box
        create_reports_directory
        upload_test_runner
        run_tests
        download_test_reports
        say "Finished!", :green
      ensure
        cleanup
      end

      def initial_setup(options)
        @gem_path = File.expand_path(File.dirname(__FILE__) + "/../..")
        @report_location = File.join(local_repository_path, "reports")

        load_config_files
        @config.merge!(options)
      end

      def revision
        @config["revision"]
      end

      def verbose?
        @config["verbose"] == true
      end

      def load_config_files
        # Load the shanty.yml file from the root of the clone of the project
        config_file = File.join(local_repository_path, "shanty.yml")
        @config = YAML::load_file(config_file)

        # Load the ~/.shanty/provider_config.yml
        @provider_config = YAML::load_file(File.join(File.expand_path(ENV['HOME']), '.shanty', "cloud_provider_config.yml"))
        @config[@config["provider"]] = @provider_config[@config["provider"]].merge(@config[@config["provider"]] || {})
        @config['puppet_path'] = File.join(local_repository_path, "puppet")

        @project_folder = File.join(File.expand_path(ENV['HOME']), '.shanty', "#{@config['project_name']}-#{revision}")
      end

      def create_project_folder
        empty_directory @project_folder, :verbose => verbose?
      end

      def create_project_archive
        inside local_repository_path do
          run "git checkout #{revision}", :verbose => verbose?
          run "git submodule update --init", :verbose => verbose?
          run "tar cf #{File.join(@project_folder, "project.tar")} --exclude .git --exclude \"*.log\" --exclude node_modules .", :verbose => verbose?
        end
      end

      def write_vagrant_file
        erb_template = File.join("templates", "providers", @config["provider"], "Vagrantfile.erb")
        destination = File.join(@project_folder, "Vagrantfile")

        template erb_template, destination, :verbose => verbose?
      end

      def write_test_runner
        erb_template = File.join("templates", "languages", @config["language"], "test_runner.sh.erb")
        destination = File.join(@project_folder, "test_runner.sh")
        template erb_template, destination, :verbose => verbose?
      end

      def install_vagrant_plugin
        inside @project_folder do
          plugin = PROVIDERS[@config["provider"]][:plugin]
          # check for vagrant plugin
          if !system("vagrant plugin list | grep -q #{plugin}")
            # if vagrant plugin is missing
            say "You are missing the Vagrant plugin for #{@config["provider"]}", :yellow
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
        if @config["vm_box_url"]
          if run "curl --output /dev/null --silent --head --fail #{@config["vm_box_url"]}"
            say "Using specified VM Box URL", :green
          else
            say "Could not resolve the Box URL: #{@config["vm_box_url"]}", :red
          end
        else
          inside @project_folder do
            dummy_box_url = PROVIDERS[@config["provider"]][:dummy_box_url]
            # check for box
            if !system("vagrant box list | grep dummy | grep -q \"(#{@config["provider"]})\"")
              # if box is missing
              say "No box found for #{@config["provider"]}, installing now...", :blue
              run "vagrant box add dummy #{dummy_box_url}", :verbose => verbose?
            else # if vagrant plugin is found
              say "Provider box found", :green
            end
          end
        end
      end

      def spin_up_box
        inside @project_folder do
          run "vagrant up --no-provision --provider #{@config["provider"]}", :verbose => verbose?
        end
      end

      def setup_ssh_config
        inside @project_folder do
          run "vagrant ssh-config > ssh-config.local", :verbose => verbose?
        end
      end

      def install_puppet_on_box
        say "Opening SSH tunnel into the box...", :blue if verbose?
        Net::SSH.start("default", "ubuntu", {:config => File.join(@project_folder, "ssh-config.local")}) do |ssh|
          say "Copying the project TAR to the box, and unpacking...", :blue if verbose?
          ssh.exec! "mkdir /vagrant/#{@config['project_name']}"
          ssh.exec! "tar xf /vagrant/project.tar -C /vagrant/#{@config['project_name']}"
          ssh.exec! "cp /vagrant/#{@config["project_name"]}/.ruby-version /vagrant"
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
        inside @project_folder do
          run "vagrant provision", :verbose => verbose?
        end
      end

      def create_reports_directory
        say "Creating the reports directory on the box...", :blue if verbose?
        Net::SSH.start("default", "ubuntu", {:config => File.join(@project_folder, "ssh-config.local")}) do |ssh|
          report_exts = @config['report_file_ext'] || ['xml']
          report_exts.each do |ext|
            ssh.exec!  "mkdir -p /vagrant/#{@config['project_name']}/reports/#{ext}"
          end
        end
      end

      def upload_test_runner
        Net::SSH.start("default", "ubuntu", {:config => File.join(@project_folder, "ssh-config.local")}) do |ssh|
          say "Uploading test_runner.sh to the box...", :blue if verbose?
          ssh.scp.upload! File.join(@project_folder, "test_runner.sh"), "/vagrant/test_runner.sh"
          say "Running: chmod a+x /vagrant/test_runner.sh", :blue if verbose?
          puts ssh.exec! "chmod a+x /vagrant/test_runner.sh"
        end
      end

      def run_tests
        Net::SSH.start("default", "ubuntu", {:config => File.join(@project_folder, "ssh-config.local")}) do |ssh|
          say "Running the test steps on the box...", :blue if verbose?
          puts ssh.exec! "/vagrant/test_runner.sh"
        end
      end

      def download_test_reports
        Net::SSH.start("default", "ubuntu", {:config => File.join(@project_folder, "ssh-config.local")}) do |ssh|
          empty_directory @report_location, :verbose => verbose?
          # say "Removing old reports...", :blue if verbose?
          Dir["#{@report_location}/*.*"].each { |file| FileUtils.rm(file) }
          say "Downloading the reports...", :blue if verbose?
          ssh.scp.download! "/vagrant/#{@config['project_name']}/reports/*", @report_location, :recursive => true
        end
      end

      def cleanup
        if @project_folder && File.directory?(@project_folder)
          say "Cleaning up...", :blue
          inside @project_folder do
            run "vagrant destroy", :verbose => verbose?
            remove_dir @project_folder, :verbose => verbose?
          end
        end
      end
    end
  end
end