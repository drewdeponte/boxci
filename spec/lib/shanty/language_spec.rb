require 'spec_helper'

describe Shanty::Language do
  describe "#generate_starter_puppet_manifest" do
    it "raises an exception when not implemented by subclass" do
      class Shanty::Provider::TestPureVirtualLanguagePuppetManifestOne < ::Shanty::Language
      end
      expect { Shanty::Provider::TestPureVirtualLanguagePuppetManifestOne.new.generate_starter_puppet_manifest }.to raise_error(Shanty::PureVirtualMethod)
    end
  end
end
