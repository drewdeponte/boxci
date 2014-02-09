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
    it "copies the cloud_provider_config to the user's root" do
      expect(subject).to receive(:copy_file).with("templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml")
      subject.create_cloud_provider_config
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

    it "assigns the current ruby version found in .ruby-version to @current_ruby_version" do
      allow(subject).to receive(:template)
      ruby_version = double
      allow(subject).to receive(:dot_ruby_version).and_return(ruby_version)
      subject.create_dot_shanty_yml('ruby')
      expect(subject.instance_variable_get(:@current_ruby_version)).to eq(ruby_version)
    end

    it "renders the dot_shanty.yml.tt from the templates to the project root .shanty.yml" do
      expect(subject).to receive(:template).with("templates/dot_shanty.yml.tt", File.join(local_repository_path, ".shanty.yml"))
      subject.create_dot_shanty_yml('ruby')
    end
  end

  describe "#dot_ruby_version" do
    context "when the .ruby-version file exists" do
      context "when format is ruby-1.9.3-p327@fooo" do
        it "returns '1.9.3-p327'" do
          allow(File).to receive(:read).and_return('ruby-1.9.3-p327@fooo')
          expect(subject.dot_ruby_version).to eq('1.9.3-p327')
        end
      end

      context "when format is ruby-2.1.0" do
        it "returns '2.1.0'" do
          allow(File).to receive(:read).and_return('ruby-2.1.0')
          expect(subject.dot_ruby_version).to eq('2.1.0')
        end
      end

      context "when format is 2.1.0" do
        it "returns '2.1.0'" do
          allow(File).to receive(:read).and_return('2.1.0')
          expect(subject.dot_ruby_version).to eq('2.1.0')
        end
      end
    end

    context "when the .ruby-version does NOT exist" do
      it "returns nil" do
        allow(File).to receive(:exist?).and_return(false)
        expect(subject.dot_ruby_version).to be_nil
      end
    end
  end
end
