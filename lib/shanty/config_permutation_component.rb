module Shanty
  class ConfigPermutationComponent
    def initialize(val)
      @val = val
    end

    def switch_to_script
      raise Shanty::PureVirtualMethod, "'switch_to_script' must be implemented by Shanty::ConfigPermutationComponent classes."
    end
  end
end
