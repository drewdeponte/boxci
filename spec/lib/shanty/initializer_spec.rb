require "spec_helper"

describe Shanty::Initializer do
  subject { Shanty::Initializer }

  describe ".init" do
    it "verifies all required dependencies are installed" do
      expect(Shanty::DependencyChecker).to receive(:verify_all)
      subject.init
    end
  end
end