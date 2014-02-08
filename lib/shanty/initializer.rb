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

      # TODO: Remove this because it isn't used here.
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
        @current_ruby_version = dot_ruby_version
        template "templates/dot_shanty.yml.tt", shanty_file
      end

      def dot_ruby_version
        dot_ruby_version_file_path = File.join(local_repository_path, ".ruby-version")
        return nil unless File.exist?(dot_ruby_version_file_path)
        dot_ruby_version_content = File.read(dot_ruby_version_file_path).strip
        if dot_ruby_version_content =~ /(?:ruby-)?(\d+\.\d+\.\d+(?:-p\d+)?)(?:@[\w\-]+)?/
          return $1
        end
      end
    end
  end
end
