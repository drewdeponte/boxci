module Shanty
  module Providers
    class Aws < ::Shanty::Provider
      PLUGIN = {
        name: "vagrant-aws",
        dummy_box_url: "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
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
