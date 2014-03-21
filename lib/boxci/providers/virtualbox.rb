module Boxci
  module Providers
    class Virtualbox < ::Boxci::Provider
      PLUGIN = {}

      no_commands do
        def generate_provider_vagrantfile
        end

        def requires_plugin?
          false
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
