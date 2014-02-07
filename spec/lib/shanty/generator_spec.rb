require "spec_helper"

describe Shanty::Generator do
  describe "#cloud_provider_config" do
    it "copies the cloud_provider_config template to the user's home directory" do
      expect(subject).to receive(:template).with("templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml")
      subject.cloud_provider_config
    end
  end

  describe "#vagrantfile" do
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
      subject.vagrantfile
    end

    it "loads the shanty config file" do
      expect(subject).to receive(:load_shanty_config)
      subject.vagrantfile
    end

    it "copies the Vagrantfile template for the specified language to the user's home directory" do
      expect(subject).to receive(:template).with("templates/languages/#{config["language"]}/Vagrantfile", File.join(local_repository_path, "Vagrantfile"))
      subject.vagrantfile
    end
  end

  describe "#puppet" do
    let(:local_repository_path) { "/some/path" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(subject).to receive(:say)
      allow(subject).to receive(:directory)
    end

    it "checks if the puppet directory is present" do
      expect(File).to receive(:directory?).with(File.join(local_repository_path, "puppet"))
      subject.puppet
    end

    context "when the puppet directory exists" do
      before do
        allow(File).to receive(:directory?).and_return(true)
      end

      it "outputs a message" do
        expect(subject).to receive(:say)
        subject.puppet
      end

      it "does not copy the template" do
        expect(subject).to_not receive(:directory)
        subject.puppet
      end
    end

    context "when not the puppet directory exists" do
      before do
        allow(File).to receive(:directory?).and_return(false)
      end

      it "copies the template to the repo" do
        expect(subject).to receive(:directory).with("templates/puppet", File.join(local_repository_path, "puppet"))
        subject.puppet
      end
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