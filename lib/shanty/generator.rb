require "thor"

module Shanty
  class Generator < Shanty::Base
    desc "cloud_provider_config", "Generate a skeleton cloud_provider_config.yml file in your home directory"
    def cloud_provider_config
      template "templates/shanty/cloud_provider_config.yml", "~/.shanty/cloud_provider_config.yml"
    end

    desc "vagrantfile", "Generate a basic Vagrantfile in your project root for the specified language in the Shanty config"
    def vagrantfile
      dependency_checker = Shanty::DependencyChecker.new
      dependency_checker.verify_shanty_config

      load_shanty_config
      template "templates/languages/#{@config["language"]}/Vagrantfile", File.join(local_repository_path, "Vagrantfile")
    end

    desc "puppet", "Generate a template structure for in your project root for the specified language in the Shanty config"
    def puppet
      if File.directory?(File.join(local_repository_path, "puppet"))
        say "Found puppet files", :green
      else
        directory "templates/puppet", File.join(local_repository_path, "puppet")
      end
    end

    no_commands do
      def load_shanty_config
        local_repository_path = File.expand_path(%x(pwd)).strip
        config_file = File.join(local_repository_path, "shanty.yml")
        @config = YAML::load_file(config_file)
      end
    end
  end
end