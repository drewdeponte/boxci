require "thor"

module Shanty
  class Base < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    no_commands do
      def local_repository_path
        if @local_repository_path.nil?
          @local_repository_path = File.expand_path(%x(pwd)).strip
        end

        return @local_repository_path
      end
    end
  end
end