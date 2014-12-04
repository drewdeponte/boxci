module Boxci
  class ProjectConfig
    def initialize
      @project_config = { 
        'language' => 'ruby', 
        'box_size' => 'small',
        'artifact_path' => '/tmp/boxci/artifacts',
        'project_folder' => 'project',
        'base_directory' => '/tmp/boxci'
      }
    end

    def load
      @project_config.merge! read_project_config_hash
    end

    def rbenv
      @project_config['rbenv']
    end

    def language
      @project_config['language']
    end

    def puppet_facts
      return [] unless @project_config['puppet_facts']
      @project_config['puppet_facts']
    end

    def box_size
      @project_config['box_size']
    end

    def artifact_path
      @project_config['artifact_path']
    end

    def base_directory
      @project_config['base_directory']
    end

    def project_directory
      @project_directory ||= File.join(@project_config['base_directory'], @project_config['project_folder'])
    end

    # Test Runner Hooks
    def before_install
      return [] unless @project_config['before_install']
      option_as_array("before_install")
    end

    def install
      return [] unless @project_config['install']
      option_as_array("install")
    end

    def before_script
      return [] unless @project_config['before_script']
      option_as_array("before_script")
    end

    def script
      return [] unless @project_config['script']
      option_as_array("script")
    end

    def after_failure
      return [] unless @project_config['after_failure']
      option_as_array("after_failure")
    end

    def after_success
      return [] unless @project_config['after_success']
      option_as_array("after_success")
    end

    def after_script
      return [] unless @project_config['after_script']
      option_as_array("after_script")
    end

    def permutations
      # permutations_of_components = [rbenv_components].inject(&:product).map(&:flatten)
      if rbenv.nil? || rbenv.empty?
        return nil
      else
        perms = []
        rbenv.each do |ver|
          perms << Boxci::ConfigPermutation.new([Boxci::ConfigPermutationComponentFactory.build('rbenv', ver)])
        end
        return perms
      end
    end

    private

    def option_as_array(key)
      if @project_config[key].is_a?(Array)
        @project_config[key]
      else
        [@project_config[key]]
      end
    end

    def read_project_config_hash
      project_config_path = File.join(Boxci.project_path, ".boxci.yml")
      return YAML::load_file(project_config_path)
    end
  end
end
