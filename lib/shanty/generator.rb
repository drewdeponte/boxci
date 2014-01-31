require "thor"

module Shanty
  class Generator < Thor
    include Thor::Actions

    class << self
      def source_root
        File.dirname(__FILE__)
      end
    end

    desc "cloud_provider_config", "Generate a skeleton cloud_provider_config.yml file in your home directory"
    def cloud_provider_config
      template "templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml"
    end
  end
end