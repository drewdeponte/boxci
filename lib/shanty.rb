require "shanty/version"
require "shanty/vm_builder"
require "shanty/dependency_checker"

module Shanty
  class MissingDependency < StandardError; end
end
