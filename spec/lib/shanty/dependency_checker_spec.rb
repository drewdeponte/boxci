require "spec_helper"

describe Shanty::DependencyChecker do
  describe "#verify_all" do
    before do
      allow(subject).to receive(:verify_vagrant)
      allow(subject).to receive(:verify_cloud_provider_config)
      allow(subject).to receive(:verify_repo_puppet_directory)
      allow(subject).to receive(:verify_vagrantfile)
    end

    it "checks if vagrant is installed" do
      expect(subject).to receive(:verify_vagrant)
      subject.verify_all
    end

    it "checks if the cloud_provider_config exists" do
      expect(subject).to receive(:verify_cloud_provider_config)
      subject.verify_all
    end

    it "verifies the repository has the required puppet directory structure" do
      expect(subject).to receive(:verify_repo_puppet_directory)
      subject.verify_all
    end

    it "verifies the vagrantfile exists" do
      expect(subject).to receive(:verify_vagrantfile)
      subject.verify_all
    end

    context "when a dependency fails" do
      before do
        allow(subject).to receive(:verify_vagrant).and_raise(Shanty::MissingDependency, "Error message 123")
        allow(subject).to receive(:exit)
        allow(subject).to receive(:puts)
      end

      it "rescues the exception" do
        expect { subject.verify_all }.to_not raise_error
      end

      it "outputs the error message" do
        expect(subject).to receive(:puts).with("Error message 123")
        subject.verify_all
      end

      it "exits" do
        expect(subject).to receive(:exit)
        subject.verify_all
      end
    end

    context "when no dependencies fail" do
      before do
        allow(Shanty::DependencyChecker).to receive(:verify_all).and_return(true)
      end

      it "does not output anything" do
        expect(subject).to_not receive(:puts)
        subject.verify_all
      end

      it "does not exit" do
        expect(subject).to_not receive(:exit)
        subject.verify_all
      end
    end
  end

  describe "#verify_vagrant" do
    it "checks if the system path includes 'vagrant'" do
      expect(subject).to receive(:system).with("which vagrant > /dev/null").and_return(true)
      subject.verify_vagrant
    end

    context "when vagrant is verified" do
      before do
        allow(subject).to receive(:system).and_return(true)
      end

      it "does not raise an error" do
        expect { subject.verify_vagrant }.to_not raise_error
      end
    end

    context "when vagrant is not verified" do
      before do
        allow(subject).to receive(:system).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_vagrant }.to raise_error(Shanty::MissingDependency)
      end
    end
  end

  describe "#verify_cloud_provider_config" do
    it "checks if the the '.cloud_provider_config' exists in the user's home dir" do
      cloud_provider_file = File.join(File.expand_path(ENV["HOME"]), ".shanty", "cloud_provider_config.yml")
      expect(File).to receive(:exists?).with(cloud_provider_file).and_return(true)
      subject.verify_cloud_provider_config
    end

    context "when the config is verified" do
      before do
        expect(File).to receive(:exists?).and_return(true)
      end

      it "does not raise an error" do
        expect { subject.verify_cloud_provider_config }.to_not raise_error
      end
    end

    context "when the config is not verified" do
      before do
        expect(File).to receive(:exists?).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_cloud_provider_config }.to raise_error(Shanty::MissingDependency)
      end
    end
  end

  describe "#verify_repo_puppet_directory" do
    let(:local_repository_path) { "/some/path" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(File).to receive(:directory?).and_return(true)
    end

    it "checks for the puppet directory in the repo root" do
      expect(File).to receive(:directory?).with(File.join(local_repository_path, "puppet")).and_return(true)
      subject.verify_repo_puppet_directory
    end

    context "when the directory is present" do
      it "does not raise an error" do
        expect { subject.verify_repo_puppet_directory }.to_not raise_error
      end
    end

    context "when the directory is not present" do
      before do
        allow(File).to receive(:directory?).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_repo_puppet_directory }.to raise_error(Shanty::MissingDependency)
      end
    end
  end

  describe "#verify_vagrantfile" do
    let(:local_repository_path) { "/some/path" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(File).to receive(:exists?).and_return(true)
    end

    it "checks for the Vagrantfile in the repo root" do
      expect(File).to receive(:exists?).with(File.join(local_repository_path, "Vagrantfile")).and_return(true)
      subject.verify_vagrantfile
    end

    context "when the vagrantfile is verified" do
      it "does not raise an error" do
        expect { subject.verify_vagrantfile }.to_not raise_error
      end
    end

    context "when the vagrantfile is not verified" do
      before do
        allow(File).to receive(:exists?).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_vagrantfile }.to raise_error(Shanty::MissingDependency)
      end
    end
  end

  describe "#verify_shanty_config" do
    let(:local_repository_path) { "/some/path" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
      allow(File).to receive(:exists?).and_return(true)
    end

    it "checks for the Shanty config file in the repo root" do
      expect(File).to receive(:exists?).with(File.join(local_repository_path, "shanty.yml")).and_return(true)
      subject.verify_shanty_config
    end

    context "when the config file is verified" do
      it "does not raise an error" do
        expect { subject.verify_shanty_config }.to_not raise_error
      end
    end

    context "when the config file is not verified" do
      before do
        allow(File).to receive(:exists?).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_shanty_config }.to raise_error(Shanty::MissingDependency)
      end
    end
  end
end