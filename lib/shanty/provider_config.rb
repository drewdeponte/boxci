module Shanty
  class ProviderConfig
    def initialize
      @provider_config = {}
    end

    def load
      @provider_config.merge!(read_provider_config_hash)
    end

    def default_provider
      @provider_config['default_provider']
    end

    private

    def read_provider_config_hash
      provider_config_path = File.join(ENV['HOME'], '/.shanty/provider_config.yml')
      provider_config = YAML::load_file(provider_config_path)
    end
  end
end
