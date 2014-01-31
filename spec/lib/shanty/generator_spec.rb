require "spec_helper"

describe Shanty::Generator do
  describe "#cloud_provider_config" do
    it "copies the cloud_provider_config template to the user's home directory" do
      expect(subject).to receive(:template).with("templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml")
      subject.cloud_provider_config
    end
  end
end