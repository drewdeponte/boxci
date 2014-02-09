require "thor"

module Shanty
  class Builder < Thor
    include Thor::Actions

    source_root(File.dirname(__FILE__))

    no_commands do
      def build
        generate_project_vagrantfile
        generate_starter_puppet_manifest
      end

      def generate_project_vagrantfile
        dependency_checker = Shanty::DependencyChecker.new
        dependency_checker.verify_shanty_config

        @project_config = Shanty.project_config
        template "templates/Vagrantfile", File.join(Shanty.project_path, "Vagrantfile")
      end

      def generate_starter_puppet_manifest
        directory "templates/puppet", File.join(Shanty.project_path, "puppet")
        language = Shanty::LanguageFactory.build(Shanty.project_config.language)
        language.generate_starter_puppet_manifest
      end
    end
  end
end
