require 'shanty/version'
require 'shanty/project_config'
require 'shanty/global_config'
require 'shanty/provider_config'
require 'shanty/initializer'
require 'shanty/builder'
require 'shanty/dependency_checker'
require 'shanty/tester'
require 'shanty/language_factory'
require 'shanty/language'
require 'shanty/languages/ruby'
require 'shanty/provider_factory'
require 'shanty/provider'
require 'shanty/providers/virtualbox'
require 'shanty/providers/aws'
require 'shanty/providers/openstack'
require 'shanty/config_permutation'
require 'shanty/config_permutation_component'
require 'shanty/config_permutation_component_factory'
require 'shanty/config_permutation_components/rbenv'
require 'shanty/test_runner'

module Shanty
  class MissingDependency < StandardError; end
  class PureVirtualMethod < StandardError; end

  def self.project_config
    if @project_config
      return @project_config
    else
      @project_config = Shanty::ProjectConfig.new
      @project_config.load
      return @project_config
    end
  end

  def self.global_config
    if @global_config
      return @global_config
    else
      @global_config = Shanty::GlobalConfig.new
      @global_config.load
      return @global_config
    end
  end

  def self.provider_config(provider)
    if @provider_config
      return @provider_config
    else
      @provider_config = Shanty::ProviderConfig.new(provider)
      @provider_config.load
      return @provider_config
    end
  end

  def self.default_provider
    if global_config.default_provider
      return global_config.default_provider
    else
      return ::Shanty::CLI::DEFAULT_PROVIDER
    end
  end

  def self.project_path
    @project_path ||= File.expand_path(%x(pwd)).strip
  end
end

# TODO: Restructure to prevent this from needing to be here.
require 'shanty/cli'
