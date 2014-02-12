require 'spec_helper'

describe Shanty::ProviderFactory do
  describe ".build" do
    it "gets the constant for the provider class" do
      expect(Shanty::Providers).to receive(:const_get).with('Aws').and_return(double.as_null_object)
      subject.build('aws')
    end

    it "constructs a new instance of the provider const it previously grabbed" do
      lang = double
      allow(Shanty::Providers).to receive(:const_get).with('Aws').and_return(lang)
      expect(lang).to receive(:new)
      subject.build('aws')
    end
  end
end
