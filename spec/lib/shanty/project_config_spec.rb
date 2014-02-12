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

  describe "#before_install" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('before_install')
      subject.before_install
    end
  end

  describe "#install" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('install')
      subject.install
    end
  end

  describe "#before_script" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('before_script')
      subject.before_script
    end
  end

  describe "#script" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('script')
      subject.script
    end
  end

  describe "#after_failure" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('after_failure')
      subject.after_failure
    end
  end

  describe "#after_success" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('after_success')
      subject.after_success
    end
  end

  describe "#after_script" do
    it "grabs the named hook as an array" do
      expect(subject).to receive(:hook_as_array).with('after_script')
      subject.after_script
    end
  end

  describe "#hook_as_array" do
    context "when the value is an array" do
      it "returns the value" do
        subject.instance_variable_set(:@project_config, { 'foo' => [1, 2, 3] })
        expect(subject.send(:hook_as_array, 'foo')).to eq([1, 2, 3])
      end
    end

    context "when not the value is not an array" do
      it "returns the value as the only item in an array" do
        subject.instance_variable_set(:@project_config, { 'foo' => 1 })
        expect(subject.send(:hook_as_array, 'foo')).to eq([1])
      end
    end
  end
end
