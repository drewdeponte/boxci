require "spec_helper"

describe Shanty::Builder do
  describe "#build" do
    it "generates project Vagrantfile" do
      allow(subject).to receive(:generate_starter_puppet_manifest)
      expect(subject).to receive(:generate_project_vagrantfile)
      subject.build
    end

    it "generates starter Puppet manifiest" do
      allow(subject).to receive(:generate_project_vagrantfile)
      expect(subject).to receive(:generate_starter_puppet_manifest)
      subject.build
    end
  end

  describe "#generate_project_vagrantfile" do
    let(:config) { {"project_name" => "shanty_test", "provider" => "openstack", "language" => "ruby"} }
    let(:local_repository_path) { "/some/path" }
    let(:dependency_checker) { double(Shanty::DependencyChecker) }

    before do
      allow(subject).to receive(:template)
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(subject).to receive(:load_shanty_config)
      allow(Shanty::DependencyChecker).to receive(:new).and_return(dependency_checker)
      allow(dependency_checker).to receive(:verify_shanty_config)
      subject.instance_variable_set(:@config, config)
    end

    it "verifies the shanty config file is present" do
      allow(dependency_checker).to receive(:verify_shanty_config)
      subject.generate_project_vagrantfile
    end

    it "loads the shanty config file" do
      expect(subject).to receive(:load_shanty_config)
      subject.generate_project_vagrantfile
    end

    it "copies the Vagrantfile template for the specified language to the user's home directory" do
      expect(subject).to receive(:template).with("templates/Vagrantfile", File.join(local_repository_path, "Vagrantfile"))
      subject.generate_project_vagrantfile
    end
  end

  describe "#generate_starter_puppet_manifiest" do
    let(:local_repository_path) { "/some/path" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
    end

    it "copies the template to the repo" do
      expect(subject).to receive(:directory).with("templates/puppet", File.join(local_repository_path, "puppet"))
      subject.generate_starter_puppet_manifest
    end
  end

  describe "#load_shanty_config" do
    let(:config_file_path) { "/some/path" }

    before do
      allow(File).to receive(:join).and_return(config_file_path)
    end

    it "uses YAML to parse the config file" do
      expect(YAML).to receive(:load_file).with(config_file_path)
      subject.load_shanty_config
    end
  end
end
