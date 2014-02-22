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
    context "when puppet facts are provided in the project config" do
      it "returns the puppet facts from the config hash" do
        facters = {"test_key" => "test_value"}
        subject.instance_variable_set(:@project_config, {"puppet_facts" => facters})
        expect(subject.puppet_facts).to eq(facters)
      end
    end
    
    context "when puppet facts are NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.puppet_facts).to eq([])
      end
    end
  end

  describe "#box_size" do
    context "when the config has a box size specified" do
      it "returns the users specified box size" do
        box_size_double = double('box size double')
        subject.instance_variable_set(:@project_config, {"box_size" => box_size_double })
        expect(subject.box_size).to eq(box_size_double)
      end
    end

    context "when the config does NOT have a box size specified" do
      it "returns the default box size" do
        expect(subject.box_size).to eq('small')
      end
    end
  end

  describe "#before_install" do
    context "when before_install is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'before_install' => double })
        expect(subject).to receive(:option_as_array).with('before_install')
        subject.before_install
      end
    end

    context "when before_install is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.before_install).to eq([])
      end
    end
  end

  describe "#install" do
    context "when install is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'install' => double })
        expect(subject).to receive(:option_as_array).with('install')
        subject.install
      end
    end

    context "when install is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.install).to eq([])
      end
    end
  end

  describe "#before_script" do
    context "when before_script is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'before_script' => double })
        expect(subject).to receive(:option_as_array).with('before_script')
        subject.before_script
      end
    end

    context "when before_script is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.before_script).to eq([])
      end
    end
  end

  describe "#script" do
    context "when script is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'script' => double })
        expect(subject).to receive(:option_as_array).with('script')
        subject.script
      end
    end

    context "when script is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.script).to eq([])
      end
    end
  end

  describe "#after_failure" do
    context "when after_failure is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'after_failure' => double })
        expect(subject).to receive(:option_as_array).with('after_failure')
        subject.after_failure
      end
    end

    context "when after_failure is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.after_failure).to eq([])
      end
    end
  end

  describe "#after_success" do
    context "when after_success is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'after_success' => double })
        expect(subject).to receive(:option_as_array).with('after_success')
        subject.after_success
      end
    end

    context "when after_success is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.after_success).to eq([])
      end
    end
  end

  describe "#after_script" do
    context "when after_script is provided in the project config" do
      it "grabs the named hook as an array" do
        subject.instance_variable_set(:@project_config, { 'after_script' => double })
        expect(subject).to receive(:option_as_array).with('after_script')
        subject.after_script
      end
    end

    context "when after_script is NOT provided in the project config" do
      it "returns an empty array" do
        subject.instance_variable_set(:@project_config, {})
        expect(subject.after_script).to eq([])
      end
    end
  end

  describe "#option_as_array" do
    context "when the value is an array" do
      it "returns the value" do
        subject.instance_variable_set(:@project_config, { 'foo' => [1, 2, 3] })
        expect(subject.send(:option_as_array, 'foo')).to eq([1, 2, 3])
      end
    end

    context "when not the value is not an array" do
      it "returns the value as the only item in an array" do
        subject.instance_variable_set(:@project_config, { 'foo' => 1 })
        expect(subject.send(:option_as_array, 'foo')).to eq([1])
      end
    end
  end
end
