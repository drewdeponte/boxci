require "thor"

module Boxci
  class Builder
    include Thor::Base
    include Thor::Actions

    source_root(File.dirname(__FILE__))

    def build
      generate_project_vagrantfile
      generate_starter_puppet_manifest
    end

    def generate_project_vagrantfile
      dependency_checker = Boxci::DependencyChecker.new
      dependency_checker.verify_boxci_config

      @project_config = Boxci.project_config
      template "templates/Vagrantfile", File.join(Boxci.project_path, "Vagrantfile")
    end

    def generate_starter_puppet_manifest
      directory "templates/puppet", File.join(Boxci.project_path, "puppet")
      language = Boxci::LanguageFactory.build(Boxci.project_config.language)
      language.generate_starter_puppet_manifest
    end
  end
end
