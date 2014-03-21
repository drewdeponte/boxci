require 'spec_helper'

describe Boxci::Language do
  describe "#before_permutation_switch" do
    it "returns empty string" do
      expect(subject.before_permutation_switch).to eq("")
    end
  end

  describe "#after_permutation_switch" do
    it "returns empty string" do
      expect(subject.after_permutation_switch).to eq("")
    end
  end

  describe "#default_script" do
    it "raises an exception when not implemented by subclass" do
      class Boxci::Provider::TestPureVirtualLanguagePuppetManifestOne < ::Boxci::Language
      end
      expect { Boxci::Provider::TestPureVirtualLanguagePuppetManifestOne.new.default_script }.to raise_error(Boxci::PureVirtualMethod)
    end
  end

  describe "#generate_starter_puppet_manifest" do
    it "raises an exception when not implemented by subclass" do
      class Boxci::Provider::TestPureVirtualLanguagePuppetManifestTwo < ::Boxci::Language
      end
      expect { Boxci::Provider::TestPureVirtualLanguagePuppetManifestTwo.new.generate_starter_puppet_manifest }.to raise_error(Boxci::PureVirtualMethod)
    end
  end
end
