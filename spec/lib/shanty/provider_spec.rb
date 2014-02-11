require 'spec_helper'

class Shanty::Provider::TestPureVirtualProviderVagrantTwo < ::Shanty::Provider
end

describe Shanty::Provider do
  describe "#generate_provider_vagrantfile" do
    it "raises an exception when not implemented by subclass" do
      expect { Shanty::Provider::TestPureVirtualProviderVagrantTwo.new.generate_provider_vagrantfile }.to raise_error(Shanty::PureVirtualMethod)
    end
  end

  describe "#plugin" do
    it "raises an exception when not implemented by subclass" do
      expect { Shanty::Provider::TestPureVirtualProviderVagrantTwo.new.plugin }.to raise_error(Shanty::PureVirtualMethod)
    end
  end

  describe "#dummy_box_url" do
    it "raises an exception when not implemented by subclass" do
      expect { Shanty::Provider::TestPureVirtualProviderVagrantTwo.new.dummy_box_url }.to raise_error(Shanty::PureVirtualMethod)
    end
  end
end
