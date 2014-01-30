module Shanty
  class DependencyChecker
    class << self
      def verify_all
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
        if !system("[ -e ~/.cloud_provider_config ] > /dev/null")
          raise Shanty::MissingDependency, "It looks like you don't have the Cloud Provider Config setup. Generate an example with: \"shanty generate cloud_provider_config\""
        end
      end
    end
  end
end