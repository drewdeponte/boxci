require 'ci_bootstrap/ssh_service'
require 'ci_bootstrap/vagrant_service'
require "ci_bootstrap/version"

module CiBootstrap
  def self.configure
    yield(configuration)
  end
end
