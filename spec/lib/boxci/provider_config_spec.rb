require 'spec_helper'

describe Boxci::ProviderConfig do
  subject { Boxci::ProviderConfig.new("aws") }

  describe "#initialize" do
    it "sets the config to sane values" do
      expect(subject.instance_variable_get(:@provider_config)).not_to be_nil
    end

    it "sets the provider instance variable to the given provider" do
      expect(subject.instance_variable_get(:@provider)).to eq('aws')
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

  describe "#fetch" do
    it "returns the value from the config hash matching the passed key" do
      configs = {"key1" => "value1", "key2" => "value2"}
      subject.instance_variable_set(:@provider_config, configs)
      expect(subject.fetch("key1")).to eq("value1")
    end
  end
end
