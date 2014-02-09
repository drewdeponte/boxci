require 'spec_helper'

describe Shanty do
  describe ".project_config" do
    context "when a shanty project config instance has already been cached" do
      it "returns the cached project config instance" do
        project_config_double = double
        subject.instance_variable_set(:@project_config, project_config_double)
        expect(subject.project_config).to eq(project_config_double)
      end
    end

    context "when a shanty project config instance has NOT been cached" do
      before do
        subject.instance_variable_set(:@project_config, nil)
      end

      it "constructs a project config instance" do
        expect(Shanty::ProjectConfig).to receive(:new).and_return(double(:load => nil))
        subject.project_config
      end

      it "caches the project config instance in an instance variable" do
        project_config_double = double(:load => nil)
        allow(Shanty::ProjectConfig).to receive(:new).and_return(project_config_double)
        subject.project_config
        expect(subject.instance_variable_get(:@project_config)).to eq(project_config_double)
      end

      it "loads the project config" do
        project_config_double = double
        allow(Shanty::ProjectConfig).to receive(:new).and_return(project_config_double)
        expect(project_config_double).to receive(:load)
        subject.project_config
      end

      it "returns the cached project config instance" do
        project_config_double = double(:load => nil)
        allow(Shanty::ProjectConfig).to receive(:new).and_return(project_config_double)
        expect(subject.project_config).to eq(project_config_double)
      end
    end
  end

  describe ".project_path" do
    context "when the value is already set" do
      before do
        subject.instance_variable_set(:@project_path, "abc")
      end

      it "returns it" do
        expect(subject.project_path).to eq("abc")
      end
    end

    context "when the value is not set" do
      before do
        subject.instance_variable_set(:@project_path, nil)
        allow(File).to receive(:expand_path).and_return("/some/path")
      end

      it "gets the project path" do
        expect(File).to receive(:expand_path).and_return("/some/path")
        subject.project_path
      end

      it "sets the result to the instance variable" do
        expect(subject.project_path).to eq("/some/path")
      end
    end
  end
end
