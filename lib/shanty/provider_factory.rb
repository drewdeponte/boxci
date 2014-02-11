module Shanty
  module ProviderFactory
    def self.build(provider)
      Shanty::Providers.const_get(provider.capitalize).new
    end
  end
end
