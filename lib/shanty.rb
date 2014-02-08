require "shanty/version"
require "shanty/base"
require "shanty/initializer"
require "shanty/builder"
require "shanty/dependency_checker"
require "shanty/tester"

module Shanty
  class MissingDependency < StandardError; end
end
