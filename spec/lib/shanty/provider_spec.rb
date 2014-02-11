require 'spec_helper'

describe Shanty::Provider do
  describe "#generate_provider_config" do
    it "raises an exception when not implemented by subclass" do
      class Shanty::Provider::TestPureVirtualProviderVagrantOne < ::Shanty::Provider
      end
      expect { Shanty::Provider::TestPureVirtualProviderVagrantOne.new.generate_provider_config }.to raise_error(Shanty::PureVirtualMethod)
    end
  end

  describe "#generate_provider_vagrantfile" do
    it "raises an exception when not implemented by subclass" do
      class Shanty::Provider::TestPureVirtualProviderVagrantTwo < ::Shanty::Provider
      end
      expect { Shanty::Provider::TestPureVirtualProviderVagrantTwo.new.generate_provider_vagrantfile }.to raise_error(Shanty::PureVirtualMethod)
    end
  end

  describe "#config" do
    it "raises an exception when not implemented by subclass" do
      class Shanty::Provider::TestPureVirtualProviderVagrantThree < ::Shanty::Provider
      end
      expect { Shanty::Provider::TestPureVirtualProviderVagrantThree.new.config }.to raise_error(Shanty::PureVirtualMethod)
    end
  end
end
