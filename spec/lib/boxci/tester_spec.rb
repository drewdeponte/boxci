require "spec_helper"

describe Boxci::Tester do
  describe "#test" do
    before do
      allow(Boxci::DependencyChecker).to receive(:verify_all)
      allow(Boxci::DependencyChecker).to receive(:create_base_files)
    end

    it "verifies all required dependencies are installed" do
      # expect(Boxci::DependencyChecker).to receive(:verify_all)
      # subject.test
    end
  end
end
