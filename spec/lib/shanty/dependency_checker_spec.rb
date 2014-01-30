require "spec_helper"

describe Shanty::DependencyChecker do
  subject { Shanty::DependencyChecker }

  describe ".verify_all" do
    it "checks if vagrant is installed" do
      expect(subject).to receive(:verify_vagrant)
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

  describe ".verify_vagrant" do
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

    context "when not vagrant is installed" do
      before do
        allow(subject).to receive(:system).and_return(false)
      end

      it "raises an error" do
        expect { subject.verify_vagrant }.to raise_error(Shanty::MissingDependency)
      end
    end
  end
end