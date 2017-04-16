module Boxci
  module Languages
    @@language_map = {}

    def self.language(language_key)
      self.languages[language_key]
    end

    def self.languages
      @@language_map
    end

    def self.add(clazz)
      language_key = self.make_key_from_class(clazz)
      self.languages[language_key] = clazz
    end

    def self.make_key_from_class(clazz)
      clazz.to_s.split('::').last.downcase
    end
  end
end
