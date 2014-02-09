module Shanty
  module Languages
    class Ruby < ::Shanty::Language

      no_commands do
        def generate_starter_puppet_manifest
          template "templates/languages/#{Shanty.project_config.language}/main.pp", File.join(Shanty.project_path, "puppet/manifests/main.pp")
        end
      end
    end
  end
end
