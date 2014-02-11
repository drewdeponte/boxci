module Shanty
  module Providers
    class Aws < ::Shanty::Provider
      PLUGIN = {
        plugin: "vagrant-aws",
        dummy_box_url: "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      }

      no_commands do
        def generate_provider_vagrantfile
        end
      end
    end
  end
end
