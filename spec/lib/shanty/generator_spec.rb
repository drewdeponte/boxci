require "spec_helper"

describe Shanty::Generator do
  describe "#cloud_provider_config" do
    it "copies the cloud_provider_config template to the user's home directory" do
      expect(subject).to receive(:template).with("templates/cloud_provider_config", "~/.cloud_provider_config")
      subject.cloud_provider_config
    end
  end
end