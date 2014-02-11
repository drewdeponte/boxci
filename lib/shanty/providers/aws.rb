module Shanty
  module Providers
    class Aws < ::Shanty::Provider

      no_commands do
        def generate_provider_config
          template "templates/providers/aws/aws.yml.tt", "~/.shanty/providers/aws.yml"
        end
      end
    end
  end
end
