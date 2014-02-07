require "spec_helper"

describe Shanty::Base do
  describe "#local_repository_path" do
    context "when the value is already set" do
      before do
        subject.instance_variable_set(:@local_repository_path, "abc")
      end

      it "returns it" do
        expect(subject.local_repository_path).to eq("abc")
      end
    end

    context "when the value is not set" do
      before do
        subject.instance_variable_set(:@local_repository_path, nil)
        allow(File).to receive(:expand_path).and_return("/some/path")
      end

      it "gets the local repository path" do
        expect(File).to receive(:expand_path).and_return("/some/path")
        subject.local_repository_path
      end

      it "sets the result to the instance variable" do
        expect(subject.local_repository_path).to eq("/some/path")
      end
    end
  end
end