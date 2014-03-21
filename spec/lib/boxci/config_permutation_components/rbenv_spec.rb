require 'spec_helper'

describe Boxci::ConfigPermutationComponents::Rbenv do
  subject { Boxci::ConfigPermutationComponents::Rbenv }
  
  describe '#switch_to_script' do
    it 'generates bash script to switch ruby verisons with rbenv' do
      comp = subject.new('2.1.0')
      expect(comp.switch_to_script).to eq("echo \"Switching to ruby 2.1.0\"\nrbenv local 2.1.0\necho \"Swithed to ruby `ruby --version`\"\n")
    end
  end
end
