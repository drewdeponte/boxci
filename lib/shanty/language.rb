module Shanty
  class Language < Thor
    include Thor::Actions

    no_commands do
      def self.source_root
        File.dirname(__FILE__)
      end

      def self.supported_languages
        @@supported_languages ||= []
      end

      def self.inherited(subclass)
        self.supported_languages << subclass.to_s.split('::').last.downcase
      end

      def generate_starter_puppet_manifest
        raise "generate_starter_puppet_manifest must be implemented on Shanty::Language classes"
      end
    end
  end
end
