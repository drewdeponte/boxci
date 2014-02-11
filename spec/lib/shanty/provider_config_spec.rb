require 'spec_helper'

describe Shanty::ProviderConfig do
  subject { Shanty::ProviderConfig }
  describe "#initialize" do
    it "sets the config to sane values" do
      provider_config = subject.new('aws')
      expect(provider_config.instance_variable_get(:@provider_config)).not_to be_nil
    end

    it "sets the provider instance variable to the given provider" do
      provider_config = subject.new('aws')
      expect(provider_config.instance_variable_get(:@provider)).to eq('aws')
    end
  end

  describe "#load" do
    it "reads the provider config hash" do
      provider_config = subject.new('aws')
      expect(provider_config).to receive(:read_provider_config_hash).and_return({})
      provider_config.load
    end

    it "merges the read project config hash with the defaults" do
      default_hash = double
      provider_config = subject.new('aws')
      provider_config.instance_variable_set(:@provider_config, default_hash)
      read_hash = double
      allow(provider_config).to receive(:read_provider_config_hash).and_return(read_hash)
      expect(default_hash).to receive(:merge!).with(read_hash)
      provider_config.load
    end
  end
end
