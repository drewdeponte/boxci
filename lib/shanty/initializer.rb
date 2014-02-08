require "thor"

module Shanty
  class Initializer < Shanty::Base
    no_commands do
      def init
        create_cloud_provider_config
        create_dot_shanty_yml
      end

      def create_cloud_provider_config
        if File.exists?(File.join(ENV['HOME'], ".shanty", "cloud_provider_config.yml"))
          say "Found cloud_provider_config.yml", :green
        else
          copy_file "templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml"
        end
      end

      def create_repo_puppet_directory
        if File.directory?(File.join(local_repository_path, "puppet"))
          say "Found puppet files", :green
        else
          directory "templates/puppet", File.join(local_repository_path, "puppet")
        end
      end

      def create_dot_shanty_yml
        shanty_file = File.join(local_repository_path, ".shanty.yml")
        if !File.exists?(shanty_file)
          copy_file "templates/.shanty.yml", shanty_file
        end
      end
    end
  end
end
