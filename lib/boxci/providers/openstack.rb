module Boxci
  module Providers
    class Openstack < ::Boxci::Provider
      PLUGIN = {
        :name => "vagrant-openstack-plugin",
        :dummy_box_url => "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"
      }

      no_commands do
        def generate_provider_vagrantfile
        end

        def requires_plugin?
          true
        end

        def plugin
          PLUGIN[:name]
        end

        def dummy_box_url
          PLUGIN[:dummy_box_url]
        end
      end
    end
  end
end
