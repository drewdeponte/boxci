module Shanty
  class DependencyChecker < Shanty::Base
    no_commands do
      def verify_all
        begin
          self.verify_vagrant
          self.verify_cloud_provider_config
          self.verify_repo_puppet_directory
          self.verify_vagrantfile
          # List other dependencies here
        rescue Shanty::MissingDependency => e
          puts e.message
          exit
        end
      end

      def verify_vagrant
        if !system("which vagrant > /dev/null")
          raise Shanty::MissingDependency, "It looks like you don't have Vagrant installed. Please install it now with: \"brew install vagrant\""
        end
      end

      def verify_cloud_provider_config
        if !File.exists?(File.join(File.expand_path(ENV["HOME"]), ".shanty", "cloud_provider_config.yml"))
          raise Shanty::MissingDependency, "It looks like you don't have the Cloud Provider Config setup. Generate an example with: \"shanty generate cloud_provider_config\""
        end
      end

      def verify_repo_puppet_directory
        puppet_directory = File.join(local_repository_path, "puppet")
        error_message = "It looks like you don't have Puppet files setup for your repository. You can generate example files by running: \"shanty init\""

        if !File.directory?(puppet_directory)
          raise Shanty::MissingDependency, error_message
        end
      end

      def verify_vagrantfile
        vagrant_file = File.join(local_repository_path, "Vagrantfile")
        if !File.exists?(vagrant_file)
          raise Shanty::MissingDependency, "It looks like you don't have a Vagrantfile setup for your repository. You can generate an example file by running: \"shanty generate vagrantfile\" "
        end
      end

      def verify_shanty_config
        config_file = File.join(local_repository_path, ".shanty.yml")
        if !File.exists?(config_file)
          raise Shanty::MissingDependency, "It looks like you're missing the Shanty configuration file. You can generate an example file by running: \"shanty init\" "
        end
      end
    end
  end
end
