# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "datascientist"
  config.vm.define "science" do |base|
  end

  # Throw in our provisioning script
  config.vm.provision "shell", path: "bootstrap.sh", privileged: false

  # Map localhost:4000 to port 4000 inside the VM
  config.vm.network "forwarded_port", guest: 8888, host: 8888

  # Create a shared folder between guest and host
  config.vm.synced_folder "notebooks/", "/srv/notebooks", create: true

  config.ssh.forward_agent = true

  # VirtualBox-specific configuration
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

end

