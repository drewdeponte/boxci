require "shanty/version"
require "shanty/vm_builder"
require "shanty/initializer"
require "shanty/dependency_checker"
require "shanty/generator"

module Shanty
  class MissingDependency < StandardError; end
end
