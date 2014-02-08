require "thor"

module Shanty
  class Initializer < Shanty::Base
    no_commands do
      def init(language)
        create_cloud_provider_config
        create_dot_shanty_yml(language)
      end

      def create_cloud_provider_config
        copy_file "templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml"
      end

      def create_repo_puppet_directory
        if File.directory?(File.join(local_repository_path, "puppet"))
          say "Found puppet files", :green
        else
          directory "templates/puppet", File.join(local_repository_path, "puppet")
        end
      end

      def create_dot_shanty_yml(language)
        shanty_file = File.join(local_repository_path, ".shanty.yml")
        @language = language
        template "templates/dot_shanty.yml.tt", shanty_file
      end
    end
  end
end
