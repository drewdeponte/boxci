module Boxci
  module LanguageFactory
    def self.build(language)
      Boxci::Languages::language(language).new
    end
  end
end
