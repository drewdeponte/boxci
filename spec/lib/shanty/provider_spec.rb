require 'spec_helper'

describe Shanty::Provider do
 describe "#generate_provider_vagrantfile" do
    it "raises an exception when not implemented by subclass" do
      class Shanty::Provider::TestPureVirtualProviderVagrantTwo < ::Shanty::Provider
      end
      expect { Shanty::Provider::TestPureVirtualProviderVagrantTwo.new.generate_provider_vagrantfile }.to raise_error(Shanty::PureVirtualMethod)
    end
  end
end
