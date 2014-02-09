module Shanty
  class Language
    def self.supported_languages
      @@supported_languages ||= []
    end

    def self.inherited(subclass)
      self.supported_languages << subclass.to_s.split('::').last.downcase
    end
  end
end
