module Boxci
  module ProviderFactory
    def self.build(provider)
      Boxci::Providers.const_get(provider.capitalize).new
    end
  end
end
