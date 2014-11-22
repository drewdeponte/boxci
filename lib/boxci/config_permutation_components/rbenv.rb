module Boxci
  module ConfigPermutationComponents
    class Rbenv < Boxci::ConfigPermutationComponent
      def switch_to_script
        <<SCRIPT
echo "Switching to ruby #{@val}"
rbenv local #{@val}
echo "Switched to ruby `ruby --version`"
SCRIPT
      end
    end
  end
end
