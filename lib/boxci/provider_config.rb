module Boxci
  class ProviderConfig
    def initialize(provider)
      @provider = provider
      @provider_config = {}
    end

    def load
      @provider_config.merge!(read_provider_config_hash)
    end

    def fetch(key)
      @provider_config.fetch(key.to_s)
    end

    private

    def read_provider_config_hash
      provider_config_path = File.join(ENV['HOME'], "/.boxci/providers/#{@provider}.yml")
      provider_config = YAML::load_file(provider_config_path)
    end
  end
end
