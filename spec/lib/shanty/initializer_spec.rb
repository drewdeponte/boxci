require "spec_helper"

describe Shanty::Initializer do
  describe "#init" do
    before do
      allow(subject).to receive(:create_home_directory_files)
      allow(subject).to receive(:create_repo_root_files)
    end

    it "creates the home directory shanty files" do
      expect(subject).to receive(:create_home_directory_files)
      subject.init
    end

    it "creates the repo root shanty files" do
      expect(subject).to receive(:create_repo_root_files)
      subject.init
    end
  end

  describe "#create_home_directory_files" do
    it "copies the shanty directory from the templates, to the user's root" do
      expect(subject).to receive(:directory).with("templates/shanty", "~/.shanty")
      subject.create_home_directory_files
    end
  end

  describe "#create_repo_root_files" do
    let(:local_repository_path) { "/somewhere" }

    before do
      subject.instance_variable_set(:@local_repository_path, local_repository_path)
      allow(subject).to receive(:copy_file)
      allow(subject).to receive(:directory)
    end

    it "copies the shanty.yml from the templates to the project root" do
      expect(subject).to receive(:copy_file).with("templates/shanty.yml", File.join(local_repository_path, "shanty.yml"))
      subject.create_repo_root_files
    end

    it "copies the Vagrantfile from the templates to the project root" do
      expect(subject).to receive(:copy_file).with("templates/Vagrantfile", File.join(local_repository_path, "Vagrantfile"))
      subject.create_repo_root_files
    end

    it "copies the puppet directory from the templates to the project root" do
      expect(subject).to receive(:directory).with("templates/puppet", File.join(local_repository_path, "puppet"))
      subject.create_repo_root_files
    end
  end
end