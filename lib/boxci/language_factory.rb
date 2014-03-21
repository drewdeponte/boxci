module Boxci
  module LanguageFactory
    def self.build(language)
      Boxci::Languages.const_get(language.capitalize).new
    end
  end
end
