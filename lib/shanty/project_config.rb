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

    def puppet_facts
      @project_config['puppet_facts']
    end

    # Test Runner Hooks
    def before_install
      hook_as_array("before_install")
    end

    def install
      hook_as_array("install")
    end

    def before_script
      hook_as_array("before_script")
    end

    def script
      hook_as_array("script")
    end

    def after_failure
      hook_as_array("after_failure")
    end

    def after_success
      hook_as_array("after_success")
    end

    def after_script
      hook_as_array("after_script")
    end

    private

    def hook_as_array(key)
      if @project_config[key].is_a?(Array)
        @project_config[key]
      else
        [@project_config[key]]
      end
    end
    
    def read_project_config_hash
      project_config_path = File.join(Shanty.project_path, ".shanty.yml")
      return YAML::load_file(project_config_path)
    end
  end
end
