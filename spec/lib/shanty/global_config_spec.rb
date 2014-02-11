require 'spec_helper'

describe Shanty::GlobalConfig do
  describe "#initialize" do
    it "sets the config to sane values" do
      subject
      expect(subject.instance_variable_get(:@global_config)).not_to be_nil
    end
  end

  describe "#load" do
    it "reads the global config hash" do
      expect(subject).to receive(:read_global_config_hash).and_return({})
      subject.load
    end

    it "merges the read project config hash with the defaults" do
      default_hash = double
      subject.instance_variable_set(:@global_config, default_hash)
      read_hash = double
      allow(subject).to receive(:read_global_config_hash).and_return(read_hash)
      expect(default_hash).to receive(:merge!).with(read_hash)
      subject.load
    end
  end

  describe "#default_provider" do
    it "returns the default_provider from the config hash" do
      allow(subject).to receive(:read_global_config_hash).and_return({'default_provider' => 'hoopty'})
      subject.load
      expect(subject.default_provider).to eq('hoopty')
    end
  end
end
