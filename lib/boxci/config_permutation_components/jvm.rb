module Boxci
  module ConfigPermutationComponents
    class Jvm < Boxci::ConfigPermutationComponent
      def switch_to_script
        <<SCRIPT
echo "Switching to java #{@val}"
/usr/sbin/update-java-alternatives -s java-1.#{@val}.0-openjdk-amd64
echo "Switched to java `java -version`"
SCRIPT
      end
    end
  end
end

