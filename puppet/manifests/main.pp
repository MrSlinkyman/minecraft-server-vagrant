Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
File { owner => 0, group => 0, mode => 0644 }
stage { 'first': }
stage { 'last': }
Stage['first'] -> Stage['main'] -> Stage['last']

import 'basic.pp'
import 'nodes.pp'

class{'basic':
  stage => first
}

include apt

# My stuff
file { '/etc/motd':
	content => "Welcome to your Vagrant-built virtual machine!  Managed by Puppet.\n"
}

# ---------------------------
# this is for installing java
exec { 'apt-get update 2':
	command => '/usr/bin/apt-get update',
	require => [ Apt::Ppa["ppa:webupd8team/java"], Package["git-core"] ],
}

apt::ppa { "ppa:webupd8team/java": }

package { ["oracle-java7-installer"]:
    ensure => present,
    require => Exec["apt-get update 2"]
}

exec {
    "accept_license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Package["curl"],
    before => Package["oracle-java7-installer"],
    logoutput => true,
  }
# ---------------------------

# Install Minecraft
exec { 'wget https://s3.amazonaws.com/Minecraft.Download/versions/1.7.5/minecraft_server.1.7.5.jar -O /home/vagrant/minecraft_server.jar':
	creates=>'/home/vagrant/server/minecraft_server.jar',
	path=>'/usr/bin'
}

# Install CraftBukkit
exec { 'wget http://dl.bukkit.org/downloads/craftbukkit/get/02389_1.6.4-R2.0/craftbukkit.jar -O /home/vagrant/craftbukkit.jar':
	creates=>'/home/vagrant/server/craftbukkit.jar',
	path=>'/usr/bin'
}

# Install public keys
#  Reminder: Copy all public keys to the directory next to Vagrantfile before running vagrant up)
exec { 'mkdir -p /home/vagrant/.ssh; cp /vagrant/*.pub /home/vagrant/.ssh; cat /home/vagrant/.ssh/*.pub >> /home/vagrant/.ssh/authorized_keys2':
	creates=>'/home/vagrant/.ssh/authorized_keys2',
	path=>['/bin','/usr/bin']
}
