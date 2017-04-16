require 'spec_helper'
require 'boxci/languages/ruby'
require 'boxci/languages'

describe Boxci::LanguageFactory do
  describe ".build" do
    it "raises an exception when asked for a non-existent class" do
      expect{ subject.build('foo') }.to raise_error(NameError)
    end

    it "gets an instance of the ruby language class" do
      Boxci::Languages.add(Boxci::Languages::Ruby)
      expect(subject.build('ruby')).to be_a(Boxci::Languages::Ruby)
    end

    it "constructs a new instance of the language const it previously grabbed" do
      lang = double
      allow(Boxci::Languages).to receive(:language).with('ruby').and_return(lang)
      expect(lang).to receive(:new)
      subject.build('ruby')
    end
  end
end
