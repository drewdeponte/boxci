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
end
