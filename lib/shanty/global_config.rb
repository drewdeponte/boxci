module Shanty
  class GlobalConfig
    def initialize
      @global_config = {}
    end

    def load
      @global_config.merge!(read_global_config_hash)
    end

    def default_provider
      @global_config['default_provider']
    end

    private

    def read_global_config_hash
      global_config_path = File.join(ENV['HOME'], '/.shanty/global_config.yml')
      global_config = YAML::load_file(global_config_path)
    end
  end
end
