require 'spec_helper'

describe Boxci::ConfigPermutationComponentFactory do
  describe ".build" do
    it "gets the constant for the config permutation component class" do
      expect(Boxci::ConfigPermutationComponents).to receive(:const_get).with('Rbenv').and_return(double.as_null_object)
      subject.build('rbenv', 'foo')
    end

    it "constructs a new instance of the config permutation component const it previously grabbed" do
      comp = double
      allow(Boxci::ConfigPermutationComponents).to receive(:const_get).with('Rbenv').and_return(comp)
      expect(comp).to receive(:new)
      subject.build('rbenv', 'foo')
    end
  end
end
