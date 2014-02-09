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
    let(:project_path) { "/some/path" }
    let(:dependency_checker) { double(Shanty::DependencyChecker, :verify_shanty_config => nil) }

    it "verifies the shanty config file is present" do
      allow(subject).to receive(:template)
      allow(Shanty).to receive(:project_config)
      allow(Shanty::DependencyChecker).to receive(:new).and_return(dependency_checker)
      expect(dependency_checker).to receive(:verify_shanty_config)
      subject.generate_project_vagrantfile
    end

    it "gets shanty project config hash" do
      allow(subject).to receive(:template)
      allow(Shanty::DependencyChecker).to receive(:new).and_return(dependency_checker)
      expect(Shanty).to receive(:project_config)
      subject.generate_project_vagrantfile
    end

    it "assigns the shanty project config to instance variable" do
      allow(subject).to receive(:template)
      allow(Shanty::DependencyChecker).to receive(:new).and_return(dependency_checker)
      project_config_double = double
      allow(Shanty).to receive(:project_config).and_return(project_config_double)
      subject.generate_project_vagrantfile
      expect(subject.instance_variable_get(:@project_config)).to eq(project_config_double)
    end

    it "copies the Vagrantfile template for the specified language to the user's home directory" do
      allow(Shanty).to receive(:project_config)
      allow(Shanty::DependencyChecker).to receive(:new).and_return(dependency_checker)
      expect(subject).to receive(:template).with("templates/Vagrantfile", File.join(Shanty.project_path, "Vagrantfile"))
      subject.generate_project_vagrantfile
    end
  end

  describe "#generate_starter_puppet_manifiest" do
    let(:project_path) { "/some/path" }

    before do
      allow(Shanty).to receive(:project_path).and_return(project_path)
      allow(Shanty).to receive(:project_config).and_return(double(:language => 'ruby'))
    end

    it "copies the template to the repo" do
      language_factory_double = double(:generate_starter_puppet_manifest => nil)
      allow(Shanty::LanguageFactory).to receive(:build).and_return(language_factory_double)
      expect(subject).to receive(:directory).with("templates/puppet", File.join(Shanty.project_path, "puppet"))
      subject.generate_starter_puppet_manifest
    end

    it "builds a shanty language object" do
      allow(subject).to receive(:directory)
      language_double = double
      project_config_double = double(:language => language_double)
      allow(Shanty).to receive(:project_config).and_return(project_config_double)
      expect(Shanty::LanguageFactory).to receive(:build).with(language_double).and_return(double.as_null_object)
      subject.generate_starter_puppet_manifest
    end

    it "generates the language specific starter puppet manifest" do
      allow(subject).to receive(:directory)
      language_obj_double = double
      allow(Shanty::LanguageFactory).to receive(:build).and_return(language_obj_double)
      expect(language_obj_double).to receive(:generate_starter_puppet_manifest)
      subject.generate_starter_puppet_manifest
    end
  end
end
