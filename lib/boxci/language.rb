module Boxci
  class Language < Thor
    include Thor::Actions

    no_commands do
      def self.source_root
        File.dirname(__FILE__)
      end

      def self.inherited(subclass)
        Boxci::Languages.add(subclass)
      end

      def before_permutation_switch
        ""
      end

      def after_permutation_switch
        ""
      end

      def default_script
        raise ::Boxci::PureVirtualMethod, "'default_script' must be implemented on Boxci::Language subclasses"
      end

      def generate_starter_puppet_manifest
        raise ::Boxci::PureVirtualMethod, "'generate_starter_puppet_manifest' must be implemented on Boxci::Language subclasses"
      end
    end
  end
end
