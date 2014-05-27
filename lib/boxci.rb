require 'boxci/version'
require 'boxci/project_config'
require 'boxci/global_config'
require 'boxci/provider_config'
require 'boxci/initializer'
require 'boxci/builder'
require 'boxci/dependency_checker'
require 'boxci/tester'
require 'boxci/language_factory'
require 'boxci/language'
require 'boxci/languages'
require 'boxci/languages/ruby'
require 'boxci/provider_factory'
require 'boxci/provider'
require 'boxci/providers/virtualbox'
require 'boxci/providers/aws'
require 'boxci/providers/openstack'
require 'boxci/config_permutation'
require 'boxci/config_permutation_component'
require 'boxci/config_permutation_component_factory'
require 'boxci/config_permutation_components/rbenv'
require 'boxci/test_runner'

module Boxci
  class MissingDependency < StandardError; end
  class PureVirtualMethod < StandardError; end
  class CommandFailed < StandardError; end

  def self.project_config
    if @project_config
      return @project_config
    else
      @project_config = Boxci::ProjectConfig.new
      @project_config.load
      return @project_config
    end
  end

  def self.global_config
    if @global_config
      return @global_config
    else
      @global_config = Boxci::GlobalConfig.new
      @global_config.load
      return @global_config
    end
  end

  def self.provider_config(provider)
    if @provider_config
      return @provider_config
    else
      @provider_config = Boxci::ProviderConfig.new(provider)
      @provider_config.load
      return @provider_config
    end
  end

  def self.default_provider
    if global_config.default_provider
      return global_config.default_provider
    else
      return ::Boxci::CLI::DEFAULT_PROVIDER
    end
  end

  def self.project_path
    @project_path ||= File.expand_path(%x(pwd)).strip
  end
end

# TODO: Restructure to prevent this from needing to be here.
require 'boxci/cli'
