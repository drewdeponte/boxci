require 'shanty/version'
require 'shanty/project_config'
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
require 'shanty/providers/aws'
require 'shanty/providers/openstack'
require 'shanty/cli'

module Shanty
  class MissingDependency < StandardError; end

  def self.project_config
    if @project_config
      return @project_config
    else
      @project_config = Shanty::ProjectConfig.new
      @project_config.load
      return @project_config
    end
  end

  def self.default_provider
    provider_config_path = File.join(ENV['HOME'], '/.shanty/provider_config.yml')
    provider_config = YAML::load_file(provider_config_path)
    default_provider = provider_config['default_provider']
    if default_provider
      return default_provider
    else
      return ::Shanty::CLI::DEFAULT_PROVIDER
    end
  end

  def self.provider_config
    if @provider_config
      return @provider_config
    else
      @provider_config = Shanty::ProviderConfig.new
      @provider_config.load
      return @provider_config
    end
  end

  def self.project_path
    @project_path ||= File.expand_path(%x(pwd)).strip
  end
end
