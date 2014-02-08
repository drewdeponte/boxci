require "thor"

module Shanty
  class Builder < Shanty::Base
    no_commands do
      def build
        generate_project_vagrantfile
        generate_starter_puppet_manifest
      end

      def generate_project_vagrantfile
        dependency_checker = Shanty::DependencyChecker.new
        dependency_checker.verify_shanty_config

        load_shanty_config
        template "templates/Vagrantfile", File.join(local_repository_path, "Vagrantfile")
      end

      def generate_starter_puppet_manifest
        directory "templates/puppet", File.join(local_repository_path, "puppet")
      end

      def load_shanty_config
        local_repository_path = File.expand_path(%x(pwd)).strip
        config_file = File.join(local_repository_path, ".shanty.yml")
        @config = YAML::load_file(config_file)
      end
    end
  end
end
