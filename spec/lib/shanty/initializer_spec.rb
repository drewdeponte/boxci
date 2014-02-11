require "spec_helper"

describe Shanty::Initializer do
  describe "#init" do
    before do
      allow(subject).to receive(:create_provider_config)
      allow(subject).to receive(:set_default_provider)
      allow(subject).to receive(:create_project_config)
    end

    it "creates provider specific config" do
      provider_double = double
      expect(subject).to receive(:create_provider_config).with(provider_double)
      subject.init(double, provider_double)
    end

    it "sets the default provider" do
      provider_double = double
      expect(subject).to receive(:set_default_provider).with(provider_double)
      subject.init(double, provider_double)
    end

    it "creates the project config" do
      language_double = double
      expect(subject).to receive(:create_project_config).with(language_double)
      subject.init(language_double, double)
    end
  end

  describe "#create_provider_config" do
    it "renders the provider specific config" do
      expect(subject).to receive(:template).with("templates/providers/foo.yml.tt", "~/.shanty/providers/foo.yml")
      subject.create_provider_config('foo')
    end
  end

  describe "#set_default_provider" do
    it "assigns the provider to an instance variable" do
      allow(subject).to receive(:template)
      subject.set_default_provider('aws')
      expect(subject.instance_variable_get(:@provider)).to eq('aws')
    end

    it "creates the global_config.yml setting the default provider" do
      expect(subject).to receive(:template).with("templates/shanty/global_config.yml.tt", "~/.shanty/global_config.yml")
      subject.set_default_provider('aws')
    end
  end

  describe "#create_project_config" do
    let(:local_repository_path) { "/somewhere" }

    before do
      allow(subject).to receive(:local_repository_path).and_return(local_repository_path)
    end

    it "assigns the given language to @language" do
      allow(subject).to receive(:template)
      language = double
      subject.create_project_config(language)
      expect(subject.instance_variable_get(:@language)).to eq(language)
    end

    it "assigns the current ruby version found in .ruby-version to @current_ruby_version" do
      allow(subject).to receive(:template)
      ruby_version = double
      allow(subject).to receive(:dot_ruby_version).and_return(ruby_version)
      subject.create_project_config('ruby')
      expect(subject.instance_variable_get(:@current_ruby_version)).to eq(ruby_version)
    end

    it "renders the dot_shanty.yml.tt from the templates to the project root .shanty.yml" do
      expect(subject).to receive(:template).with("templates/dot_shanty.yml.tt", File.join(Shanty.project_path, ".shanty.yml"))
      subject.create_project_config('ruby')
    end
  end

  describe "#dot_ruby_version" do
    context "when the .ruby-version file exists" do
      before do
        allow(File).to receive(:exist?).and_return(true)
      end

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
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it "returns nil" do
        allow(File).to receive(:exist?).and_return(false)
        expect(subject.dot_ruby_version).to be_nil
      end
    end
  end
end
