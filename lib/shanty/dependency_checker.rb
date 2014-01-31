module Shanty
  class DependencyChecker
    attr_accessor :local_repository_path

    class << self
      def verify_all
        @local_repository_path = File.expand_path(%x(pwd)).strip
        begin
          self.verify_vagrant
          self.verify_cloud_provider_config
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
        if !system("[ -e ~/.shanty/cloud_provider_config.yml ] > /dev/null")
          raise Shanty::MissingDependency, "It looks like you don't have the Cloud Provider Config setup. Generate an example with: \"shanty generate cloud_provider_config\""
        end
      end

      def verify_repo_puppet_files
        vagrant_file = File.join(@local_repository_path, "Vagrantfile")
        puppet_directory = File.join(@local_repository_path, "puppet")
        manifest_file = File.join(@local_repository_path, "puppet", "manifests", "main.pp")
        error_message = "It looks like you don't have a Vagrant/Puppet setup for your repository. You can generate example files by running: \"shanty init\""

        if !File.exists?(vagrant_file) || !File.directory?(puppet_directory) || !File.exists?(manifest_file)
          raise Shanty::MissingDependency, error_message
        end
      end
    end
  end
end