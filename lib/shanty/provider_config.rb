module Shanty
  class ProviderConfig
    def initialize
      @provider_config = {}
    end

    def load
      @provider_config.merge!(read_provider_config_hash)
    end

    private

    def read_provider_config_hash
    end
  end
end
