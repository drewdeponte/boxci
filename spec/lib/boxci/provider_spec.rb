require 'spec_helper'

class Boxci::Provider::TestPureVirtualProviderVagrantTwo < ::Boxci::Provider
end

describe Boxci::Provider do
  describe "#generate_provider_vagrantfile" do
    it "raises an exception when not implemented by subclass" do
      expect { Boxci::Provider::TestPureVirtualProviderVagrantTwo.new.generate_provider_vagrantfile }.to raise_error(Boxci::PureVirtualMethod)
    end
  end

  describe "#requires_plugin?" do
    it "raises an exception when not implemented by subclass" do
      expect { Boxci::Provider::TestPureVirtualProviderVagrantTwo.new.requires_plugin? }.to raise_error(Boxci::PureVirtualMethod)
    end
  end

  describe "#plugin" do
    it "raises an exception when not implemented by subclass" do
      expect { Boxci::Provider::TestPureVirtualProviderVagrantTwo.new.plugin }.to raise_error(Boxci::PureVirtualMethod)
    end
  end

  describe "#dummy_box_url" do
    it "raises an exception when not implemented by subclass" do
      expect { Boxci::Provider::TestPureVirtualProviderVagrantTwo.new.dummy_box_url }.to raise_error(Boxci::PureVirtualMethod)
    end
  end
end
