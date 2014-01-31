require "spec_helper"

describe Shanty::Initializer do
  describe ".init" do
    before do
      allow(Shanty::DependencyChecker).to receive(:verify_all)
      allow(Shanty::DependencyChecker).to receive(:create_base_files)
    end

    it "verifies all required dependencies are installed" do
      expect(Shanty::DependencyChecker).to receive(:verify_all)
      subject.init
    end

    it "creates the base shanty files" do
      expect(subject).to receive(:create_base_files)
      subject.init
    end
  end
end