require 'spec_helper'

describe Shanty::ProjectConfig do
  describe "#initialize" do
    it "sets the config has to sane values" do
      subject
      expect(subject.instance_variable_get(:@project_config)).not_to be_nil
    end
  end

  describe "#load" do
    it "reads the project config hash" do
      expect(subject).to receive(:read_project_config_hash).and_return({})
      subject.load
    end

    it "merges the read project config hash with the defaults" do
      default_hash = double
      subject.instance_variable_set(:@project_config, default_hash)
      read_hash = double
      allow(subject).to receive(:read_project_config_hash).and_return(read_hash)
      expect(default_hash).to receive(:merge!).with(read_hash)
      subject.load
    end
  end

  describe "#language" do
    it "returns the language from the config hash" do
      allow(subject).to receive(:read_project_config_hash).and_return({'language' => 'java'})
      subject.load
      expect(subject.language).to eq('java')
    end
  end

  describe "#puppet_facts" do
    it "returns the puppet facters from the config hash" do
      facters = {"test_key" => "test_value"}
      subject.instance_variable_set(:@project_config, {"puppet_facts" => facters})
      expect(subject.puppet_facts).to eq(facters)
    end
  end

  describe "#hook_as_array" do
    context "when the value is an array" do
      it "returns the value"
    end

    context "when not the value is not an array" do
      it "returns the value as the only item in an array"
    end
  end

  it "add all the tests for the script hooks!" do
    pending
    # before_install
    # install
    # before_script
    # script
    # after_failure
    # after_success
    # after_script
  end
end