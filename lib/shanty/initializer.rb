module Shanty
  class Initializer
    class << self
      def do_init
        puts "Initializing Shanty in #{`pwd`}"
        sleep 2
        puts "Done!"
      end
    end
  end
end