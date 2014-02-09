module Shanty
  module LanguageFactory
    def self.build(language)
      Shanty::Languages.const_get(language.capitalize).new
    end
  end
end
