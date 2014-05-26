module Boxci
  module Languages
    @@language_map = {}

    #
    # gets a language by its key (a downcased string)
    #
    def self.language(lang)
      self.langs[lang]
    end

    # 
    # returns underlying map of languages with key, value representation, e.g., 
    # 'ruby' => Boxci::Languages::Ruby
    #
    def self.langs()
      @@language_map
    end

    #
    # adds a language to langs using the downcased form of the class name
    #
    def self.add(clazz)
      lang_key = self.make_key_from_class(clazz)
      self.langs[lang_key] = clazz
    end

    # 
    # convenience method for creating a key from a class
    #
    def self.make_key_from_class(clazz)
      lang_key = clazz.to_s.split('::').last.downcase
    end
  end
end
