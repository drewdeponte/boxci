require "thor"

module Shanty
  class Initializer < Thor
    include Thor::Actions

    class << self
      def source_root
        File.dirname(__FILE__)
      end
    end

    desc "", "" #TODO: Figure out how to remove
    def init
      Shanty::DependencyChecker.verify_all
      create_base_files
    end

    no_commands do
      def create_base_files
        directory "templates/.shanty", ".shanty"
      end
    end
  end
end