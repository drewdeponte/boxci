module Boxci
  class ConfigPermutationComponent
    def initialize(val)
      @val = val
    end

    def switch_to_script
      raise Boxci::PureVirtualMethod, "'switch_to_script' must be implemented by Boxci::ConfigPermutationComponent classes."
    end
  end
end
