# -*- mode: ruby -*-
# vi: set ft=ruby :

#Vagrant::Config.run do |config|
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"

  config.vm.network "forwarded_port", guest: 25000, host: 25000
  config.vm.network "forwarded_port", guest: 25565, host: 25565

  config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  
     # Use VBoxManage to customize the VM. For example to change memory:
     vb.customize ["modifyvm", :id, "--memory", "2048"]
     vb.customize ["modifyvm", :id, "--cpus", "3"]
   end

  # This shell provisioner installs librarian-puppet and runs it to install
  # puppet modules. After that it just runs puppet
  config.vm.provision :shell, :path => "shell/bootstrap.sh"

end
