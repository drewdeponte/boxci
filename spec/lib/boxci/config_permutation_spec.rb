require 'spec_helper'

describe Boxci::ConfigPermutation do
  describe "#initialize" do
    it "constructs an instance of a Boxci::ConfigPermutation given an array of config permutation components" do
      config_permutation_components = [double, double, double]
      config_permutation = Boxci::ConfigPermutation.new(config_permutation_components)
    end

    it "assigns the given components array to an instance variable" do
      config_permutation_components = [double, double, double]
      config_permutation = Boxci::ConfigPermutation.new(config_permutation_components)
      expect(config_permutation.instance_variable_get(:@components)).to eq(config_permutation_components)
    end
  end

  describe "#switch_to_script" do
    it "grabs the switch to scripts of each of the components and joins them together with newlines" do
      comp1 = double(:switch_to_script => 'a')
      comp2 = double(:switch_to_script => 'b')
      comp3 = double(:switch_to_script => 'c')
      config_permutation_components = [comp1, comp2, comp3]
      config_permutation = Boxci::ConfigPermutation.new(config_permutation_components)
      expect(config_permutation.switch_to_script).to eq("a\nb\nc")
    end
  end
end
