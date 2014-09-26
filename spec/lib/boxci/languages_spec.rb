require 'spec_helper'

describe Boxci::Languages do
  describe ".language" do
    it "returns a class if the language exists" do
      expect(subject.language('ruby')).to eq(Boxci::Languages::Ruby)
    end
  end

  describe ".add" do
    it "adds a language to its internal storage" do
      subject.add(Boxci::Languages::Ruby)
      expect(Boxci::Languages.languages).to have_key('ruby')
    end
  end

  describe ".make_key_from_class" do
    it "returns a class if the language exists" do
      expect(subject.make_key_from_class(Boxci::Languages::Ruby)).to eq('ruby')
    end
  end

end
