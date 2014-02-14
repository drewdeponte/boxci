module Shanty
  module ConfigPermutationComponentFactory
    def self.build(key, val)
      Shanty::ConfigPermutationComponents.const_get(key.capitalize).new(val)
    end
  end
end
