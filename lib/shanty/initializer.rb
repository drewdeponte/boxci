require "thor"

module Shanty
  class Initializer < Thor
    include Thor::Actions

    source_root(File.dirname(__FILE__))

    no_commands do
      def init(language, provider)
        create_provider_config(provider)
        set_default_provider(provider)
        create_project_config(language)
      end

      def create_provider_config(provider)
        provider = Shanty::ProviderFactory.build(provider)
        provider.generate_provider_config
      end

      def set_default_provider(provider)
        @provider = provider
        template "templates/shanty/provider_config.yml.tt", "~/.shanty/provider_config.yml"
      end

      def create_project_config(language)
        shanty_file = File.join(Shanty.project_path, ".shanty.yml")
        @language = language
        @current_ruby_version = dot_ruby_version
        template "templates/dot_shanty.yml.tt", shanty_file
      end

      def dot_ruby_version
        dot_ruby_version_file_path = File.join(Shanty.project_path, ".ruby-version")
        return nil unless File.exist?(dot_ruby_version_file_path)
        dot_ruby_version_content = File.read(dot_ruby_version_file_path).strip
        if dot_ruby_version_content =~ /(?:ruby-)?(\d+\.\d+\.\d+(?:-p\d+)?)(?:@[\w\-]+)?/
          return $1
        end
      end
    end
  end
end
