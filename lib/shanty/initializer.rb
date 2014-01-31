require "thor"

module Shanty
  class Initializer < Thor
    attr_accessor :local_repository_path

    include Thor::Actions

    class << self
      def source_root
        File.dirname(__FILE__)
      end
    end

    desc "", "" #TODO: Figure out how to remove
    def init
      Shanty::DependencyChecker.verify_all
      @local_repository_path = File.expand_path(%x(pwd)).strip
      create_home_directory_files
      create_repo_root_files
    end

    no_commands do
      def create_home_directory_files
        directory "templates/shanty", "~/.shanty"
      end

      def create_repo_root_files
        copy_file "templates/shanty.yml", File.join(@local_repository_path, "shanty.yml")
        copy_file "templates/Vagrantfile", File.join(@local_repository_path, "Vagrantfile")
        directory "templates/puppet", File.join(@local_repository_path, "puppet")
      end
    end
  end
end