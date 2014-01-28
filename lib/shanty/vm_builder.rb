module Shanty
  class VMBuilder
    class << self
      def build
        puts "Building your Shanty VM..."
        sleep 2
        puts "Done!"
      end

      def build!
        puts "Existing VM found, replacing it due to 'force' argument"
        puts "Removing existing VM..."
        sleep 1
        self.build
      end
    end
  end
end