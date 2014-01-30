module Shanty
  class Initializer
    class << self
      def init
        Shanty::DependencyChecker.verify_all
      end
    end
  end
end