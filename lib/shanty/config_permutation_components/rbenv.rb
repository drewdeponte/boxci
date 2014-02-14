module Shanty
  module ConfigPermutationComponents
    class Rbenv < Shanty::ConfigPermutationComponent
      def switch_to_script
        <<SCRIPT
echo "Switching to ruby #{@val}"
rbenv local #{@val}
echo "Swithed to ruby `ruby --version`"
SCRIPT
      end
    end
  end
end
