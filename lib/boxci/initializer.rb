require "thor"

module Boxci
  class Initializer
    include Thor::Base
    include Thor::Actions
    source_root(File.dirname(__FILE__))

    def init(language, provider)
      create_provider_config(provider)
      set_default_provider(provider)
      create_project_config(language)
    end

    def create_provider_config(provider)
      template "templates/providers/#{provider}.yml.tt", "~/.boxci/providers/#{provider}.yml"
    end

    # TODO: Change this name to create_global_config
    def set_default_provider(provider)
      @provider = provider
      template "templates/boxci/global_config.yml.tt", "~/.boxci/global_config.yml"
    end

    def create_project_config(language)
      boxci_file = File.join(Boxci.project_path, ".boxci.yml")
      @language = language
      @current_ruby_version = dot_ruby_version
      template "templates/dot_boxci.yml.tt", boxci_file
    end

    def dot_ruby_version
      dot_ruby_version_file_path = File.join(Boxci.project_path, ".ruby-version")
      return nil unless File.exist?(dot_ruby_version_file_path)
      dot_ruby_version_content = File.read(dot_ruby_version_file_path).strip
      if dot_ruby_version_content =~ /(?:ruby-)?(\d+\.\d+\.\d+(?:-p\d+)?)(?:@[\w\-]+)?/
        return $1
      end
    end
  end
end
