# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ci_bootstrap/version'

Gem::Specification.new do |spec|
  spec.name          = "ci_bootstrap"
  spec.version       = CiBootstrap::VERSION
  spec.authors       = ["Brian Miller"]
  spec.email         = ["brian.miller@reachlocal.com"]
  spec.description   = %q{Tools to run CI jobs on vagrant instances}
  spec.summary       = %q{Tools to run CI jobs on vagrant instances}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ssh"
  spec.add_dependency "net-scp"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
