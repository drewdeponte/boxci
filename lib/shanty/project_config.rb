module Shanty
  class ProjectConfig
    def initialize
      @project_config = { 'language' => 'ruby' }
    end

    def load
      @project_config.merge! read_project_config_hash
    end

    def language
      @project_config['language']
    end

    private
    
    def read_project_config_hash
      local_repository_path = File.expand_path(%x(pwd)).strip
      project_config_path = File.join(local_repository_path, ".shanty.yml")
      return YAML::load_file(project_config_path)
    end
  end
end
