module Shanty
  module Providers
    class Openstack < ::Shanty::Provider
      PLUGIN = {
        name: "vagrant-openstack-plugin",
        dummy_box_url: "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"
      }

      no_commands do
        def generate_provider_vagrantfile
        end
      end
    end
  end
end
