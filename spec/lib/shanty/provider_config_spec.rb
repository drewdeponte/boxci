require 'spec_helper'

describe Shanty::ProviderConfig do
  describe "#initialize" do
    it "sets the config to sane values" do
      subject
      expect(subject.instance_variable_get(:@provider_config)).not_to be_nil
    end
  end

  describe "#load" do
    it "reads the provider config hash" do
      expect(subject).to receive(:read_provider_config_hash).and_return({})
      subject.load
    end

    it "merges the read project config hash with the defaults" do
      default_hash = double
      subject.instance_variable_set(:@provider_config, default_hash)
      read_hash = double
      allow(subject).to receive(:read_provider_config_hash).and_return(read_hash)
      expect(default_hash).to receive(:merge!).with(read_hash)
      subject.load
    end
  end
end
