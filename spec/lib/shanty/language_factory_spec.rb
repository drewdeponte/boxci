require 'spec_helper'

describe Shanty::LanguageFactory do
  describe ".build" do
    it "gets the constant for the language class" do
      expect(Shanty::Languages).to receive(:const_get).with('Ruby').and_return(double.as_null_object)
      subject.build('ruby')
    end

    it "constructs a new instance of the language const it previously grabbed" do
      lang = double
      allow(Shanty::Languages).to receive(:const_get).with('Ruby').and_return(lang)
      expect(lang).to receive(:new)
      subject.build('ruby')
    end
  end
end
