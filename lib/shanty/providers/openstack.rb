module Shanty
  module Providers
    class Openstack < ::Shanty::Provider

      no_commands do
        def generate_provider_vagrantfile
        end
      end
    end
  end
end
