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

        @project_config = Shanty.project_config
        template "templates/Vagrantfile", File.join(local_repository_path, "Vagrantfile")
      end

      def generate_starter_puppet_manifest
        directory "templates/puppet", File.join(local_repository_path, "puppet")
        # TODO: split this out into a LanguageFactory
        # language = Shanty::LanguageFactory.build(Shanty.project_config.language)
        # language.generate_starter_puppet_manifest
      end
    end
  end
end
