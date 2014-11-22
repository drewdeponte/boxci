module Boxci
  module Languages
    class Java < ::Boxci::Language

      no_commands do
        def default_script
          %q{mvn test}
        end

        def before_permutation_switch
          "export JAVA_HOME=/usr/lib/jvm/java-1.#{Boxci.project_config.jvm.first}.0-openjdk-amd64"
        end

        def generate_starter_puppet_manifest
          @project_config = Boxci.project_config
          template "templates/languages/#{@project_config.language}/main.pp", File.join(Boxci.project_path, "puppet/manifests/main.pp")
        end
      end
    end
  end
end
