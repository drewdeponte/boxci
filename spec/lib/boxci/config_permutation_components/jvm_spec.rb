require 'spec_helper'

describe Boxci::ConfigPermutationComponents::Jvm do
  subject { Boxci::ConfigPermutationComponents::Jvm }
  
  describe '#switch_to_script' do
    it 'generates bash script to switch java verisons with jvm' do
      comp = subject.new('7')
      expect(comp.switch_to_script).to eq("echo \"Switching to java 7\"\n/usr/sbin/update-java-alternatives -s java-1.7.0-openjdk-amd64\necho \"Switched to java `java -version`\"\n")
    end
  end
end

