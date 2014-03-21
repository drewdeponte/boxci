# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxci/version'

Gem::Specification.new do |spec|
  spec.name          = "boxci"
  spec.version       = Boxci::VERSION
  spec.authors       = ["Andrew De Ponte", "Brian Miller", "Russell Cloak"]
  spec.email         = ["cyphactor@gmail.com", "brimil01@gmail.com", "russcloak@gmail.cm"]
  spec.summary       = %q{Tool simplifying Vagrant based development & continuous integration environments.}
  spec.description   = %q{Boxci is focused on defining standards and building tooling around using Vagrant for development & continuous integration environments to make using them as easy as possible.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.18"
  spec.add_runtime_dependency "net-ssh", "~> 2.7"
  spec.add_runtime_dependency "net-scp", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rake", "~> 10.1"
end
