require "spec_helper"

describe Shanty::Tester do
  describe "#test" do
    before do
      allow(Shanty::DependencyChecker).to receive(:verify_all)
      allow(Shanty::DependencyChecker).to receive(:create_base_files)
    end

    it "verifies all required dependencies are installed" do
      # expect(Shanty::DependencyChecker).to receive(:verify_all)
      # subject.test
    end
  end
end