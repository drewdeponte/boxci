require "spec_helper"

describe Shanty::Initializer do
  describe "#init" do
    before do
      allow(subject).to receive(:create_cloud_provider_config)
      allow(subject).to receive(:create_dot_shanty_yml)
    end

    it "creates the cloud_provider_config file" do
      expect(subject).to receive(:create_cloud_provider_config)
      subject.init(double)
    end

    it "creates the shanty yaml file" do
      expect(subject).to receive(:create_dot_shanty_yml)
      subject.init(double)
    end
  end

  describe "#create_cloud_provider_config" do
    before do
      allow(subject).to receive(:say)
    end

    it "checks if the file exists" do
      expect(File).to receive(:exists?) do |path|
        expect(path).to include("cloud_provider_config.yml")
      end

      subject.create_cloud_provider_config
    end

    context "when the file already exist" do
      before do
        allow(File).to receive(:exists?).and_return(true)
      end

      it "does nothing" do
        subject.create_cloud_provider_config
        expect(subject).to_not receive(:copy_file)
      end
    end

    context "when the file doesn't already exist" do
      before do
        allow(File).to receive(:exists?).and_return(false)
      end

      it "copies the cloud_provider_config to the user's root" do
        expect(subject).to receive(:copy_file).with("templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml")
        subject.create_cloud_provider_config
      end
    end
  end

  describe "#create_repo_puppet_directory" do
    let(:local_repository_path) { "/somewhere" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(subject).to receive(:say)
    end

    context "when the puppet directory exists" do
      before do
        allow(File).to receive(:directory?).and_return(true)
      end

      it "outputs that it found the file" do
        expect(subject).to receive(:say)
        subject.create_repo_puppet_directory
      end

      it "does not copy the template directory" do
        expect(subject).to_not receive(:directory)
        subject.create_repo_puppet_directory
      end
    end

    context "when the puppet directory does not exist" do
      before do
        allow(subject).to receive(:directory)
      end

      it "copies the template puppet directory to the project root" do
        expect(subject).to receive(:directory).with("templates/puppet", File.join(local_repository_path, "puppet"))
        subject.create_repo_puppet_directory
      end
    end
  end

  describe "#create_dot_shanty_yml" do
    let(:local_repository_path) { "/somewhere" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
    end

    it "assigns the given language to @language" do
      allow(subject).to receive(:template)
      language = double
      subject.create_dot_shanty_yml(language)
      expect(subject.instance_variable_get(:@language)).to eq(language)
    end

    it "renders the dot_shanty.yml.tt from the templates to the project root .shanty.yml" do
      expect(subject).to receive(:template).with("templates/dot_shanty.yml.tt", File.join(local_repository_path, ".shanty.yml"))
      subject.create_dot_shanty_yml('ruby')
    end
  end
end
