module Boxci
  class ConfigPermutation
    def initialize(components)
      @components = components
    end

    def switch_to_script
      component_scripts = []
      @components.each do |component|
        component_scripts << component.switch_to_script
      end
      return component_scripts.join("\n")
    end
  end
end
