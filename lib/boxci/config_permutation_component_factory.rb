module Boxci
  module ConfigPermutationComponentFactory
    def self.build(key, val)
      Boxci::ConfigPermutationComponents.const_get(key.capitalize).new(val)
    end
  end
end
