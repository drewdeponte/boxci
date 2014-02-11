module Shanty
  module Providers
    class Openstack < ::Shanty::Provider

      no_commands do
        def generate_provider_config
          template "templates/providers/openstack/openstack.yml.tt", "~/.shanty/providers/openstack.yml"
        end
      end
    end
  end
end
