module Shanty
  module Languages
    class Ruby < ::Shanty::Language

      no_commands do
        def generate_starter_puppet_manifest
          @project_config = Shanty.project_config
          if @project_config.rbenv
            inside Shanty.project_path do
              run "git submodule add -f git@github.com:alup/puppet-rbenv.git puppet/modules/rbenv"
              run "git submodule update --init"
            end
          end
          template "templates/languages/#{Shanty.project_config.language}/main.pp", File.join(Shanty.project_path, "puppet/manifests/main.pp")
        end
      end
    end
  end
end
