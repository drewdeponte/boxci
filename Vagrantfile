# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider :virtualbox do |vb|
  
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  
  end

  config.vm.provision "puppet" do |puppet|
    puppet.facter = {
      "vagrant_user" => "vagrant",
      "vagrant_home" => "/home/vagrant"
    }
    # puppet.options = "--verbose --debug"
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "main.pp"
  end
end
