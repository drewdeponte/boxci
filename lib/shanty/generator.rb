require "thor"

module Shanty
  class Generator < Thor
    include Thor::Actions

    class << self
      def source_root
        File.dirname(__FILE__)
      end
    end

    desc "cloud_provider_config", "Generate a skeleton ~/.cloud_provider_config file"
    def cloud_provider_config
      template "templates/cloud_provider_config", "~/.cloud_provider_config"
    end
  end
end