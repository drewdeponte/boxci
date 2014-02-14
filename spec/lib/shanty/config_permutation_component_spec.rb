require 'spec_helper'

describe Shanty::ConfigPermutationComponent do
  subject { Shanty::ConfigPermutationComponent }

  describe '#initialize' do
    it 'assigns the given value to an instance variable' do
      config_permutation_component = subject.new('foeue')
      expect(config_permutation_component.instance_variable_get(:@val)).to eq('foeue')
    end
  end

  describe '#switch_to_script' do
    it 'raises exception stating it is pure virtual method' do
      config_permutation_component = subject.new('foeue')
      expect { config_permutation_component.switch_to_script }.to raise_error(Shanty::PureVirtualMethod)
    end
  end
end
