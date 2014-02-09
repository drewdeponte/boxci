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
end
