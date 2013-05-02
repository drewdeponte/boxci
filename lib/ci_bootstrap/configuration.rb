module CIBootstrap
  def self.configuration
    @configuration ||= CIBootstrap::Configuration.new
  end

  class Configuration
    attr_accessor :workspace
    attr_accessor :rev
    attr_accessor :provider_config
    attr_accessor :project_config
    attr_accessor :root_path
  end
end
