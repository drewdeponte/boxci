module Boxci
  class DependencyChecker < Thor
    include Thor::Actions

    no_commands do
      def verify_all
        begin
          self.verify_vagrant
          self.verify_cloud_provider_config
          self.verify_repo_puppet_directory
          self.verify_vagrantfile
          # List other dependencies here
        rescue Boxci::MissingDependency => e
          puts e.message
          exit
        end
      end

      def verify_vagrant
        if !system("which vagrant > /dev/null")
          raise Boxci::MissingDependency, "It looks like you don't have Vagrant installed. Please install it now with: \"brew install vagrant\""
        end
      end

      def verify_cloud_provider_config
        if !File.exists?(File.join(File.expand_path(ENV["HOME"]), ".boxci", "cloud_provider_config.yml"))
          raise Boxci::MissingDependency, "It looks like you don't have the Cloud Provider Config setup. Generate an example with: \"boxci generate cloud_provider_config\""
        end
      end

      def verify_repo_puppet_directory
        puppet_directory = File.join(Boxci.project_path, "puppet")
        error_message = "It looks like you don't have Puppet files setup for your repository. You can generate example files by running: \"boxci init\""

        if !File.directory?(puppet_directory)
          raise Boxci::MissingDependency, error_message
        end
      end

      def verify_vagrantfile
        vagrant_file = File.join(Boxci.project_path, "Vagrantfile")
        if !File.exists?(vagrant_file)
          raise Boxci::MissingDependency, "It looks like you don't have a Vagrantfile setup for your repository. You can generate an example file by running: \"boxci generate vagrantfile\" "
        end
      end

      def verify_boxci_config
        config_file = File.join(Boxci.project_path, ".boxci.yml")
        if !File.exists?(config_file)
          raise Boxci::MissingDependency, "It looks like you're missing the Boxci configuration file. You can generate an example file by running: \"boxci init\" "
        end
      end
    end
  end
end
