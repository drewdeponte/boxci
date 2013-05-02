module CIBootstrap
  class VagrantService
    class << self
      def vagrant?
        system("which vagrant")
      end

      def has_plugin?(plugin)
        system("vagrant plugin list | grep -q #{plugin}")
      end

      def aws_plugin?
        has_plugin?("vagrant-aws")
      end

      def openstack_plugin?
        has_plugin?("vagrant-openstack-plugin")
      end

      def install_plugin(plugin)
        `vagrant plugin install #{plugin}`
      end

      def install_aws_plugin
        install_plugin("vagrant-aws")
      end

      def install_openstack_plugin
        install_plugin("vagrant-openstack-plugin")
      end

      def dummy_box?
        system("vagrant box list | grep -q dummy")
      end

      def install_dummy_box
        `vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box`
      end

    end
  end
end
