require "shanty/version"
require "shanty/base"
require "shanty/vm_builder"
require "shanty/initializer"
require "shanty/dependency_checker"
require "shanty/generator"
require "shanty/tester"

module Shanty
  class MissingDependency < StandardError; end
end
