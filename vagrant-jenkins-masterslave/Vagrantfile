# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #create a jenkins master server
   config.vm.define :jenkins do |jenkins_config|
      jenkins_config.vm.box = "centos/7"
      jenkins_config.vm.hostname = "jenkins"
      jenkins_config.vm.network :private_network, ip: "10.0.15.12"
      jenkins_config.vm.network "forwarded_port", guest: 8080, host: 8090
      jenkins_config.vm.network "forwarded_port", guest: 8081, host: 8091
      jenkins_config.vm.network "forwarded_port", guest: 8082, host: 8092
      jenkins_config.vm.network "forwarded_port", guest: 8083, host: 8093
      jenkins_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      jenkins_config.vm.provision :shell, path: "bootstrap-jenkins-master.sh"
  end
  #create a jenkins slave1
   config.vm.define :jenkinsslave1 do |jenkinsslave1_config|
      jenkinsslave1_config.vm.box = "centos/7"
      jenkinsslave1_config.vm.hostname = "jenkins-slave1"
      jenkinsslave1_config.vm.network :private_network, ip: "10.0.15.13"
      jenkinsslave1_config.vm.network "forwarded_port", guest: 8080, host: 9090
      jenkinsslave1_config.vm.network "forwarded_port", guest: 8081, host: 9091
      jenkinsslave1_config.vm.network "forwarded_port", guest: 8082, host: 9092
      jenkinsslave1_config.vm.network "forwarded_port", guest: 8083, host: 9093
      jenkinsslave1_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      jenkinsslave1_config.vm.provision :shell, path: "bootstrap-jenkins-slave.sh"
  end
    #create a jenkins slave2
  config.vm.define :jenkinsslave2 do |jenkinsslave2_config|
      jenkinsslave2_config.vm.box = "centos/7"
      jenkinsslave2_config.vm.hostname = "jenkins-slave2"
      jenkinsslave2_config.vm.network :private_network, ip: "10.0.15.14"
      jenkinsslave2_config.vm.network "forwarded_port", guest: 8080, host: 7090
      jenkinsslave2_config.vm.network "forwarded_port", guest: 8081, host: 7091
      jenkinsslave2_config.vm.network "forwarded_port", guest: 8082, host: 7092
      jenkinsslave2_config.vm.network "forwarded_port", guest: 8083, host: 7093
      jenkinsslave2_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      jenkinsslave2_config.vm.provision :shell, path: "bootstrap-jenkins-slave.sh"
  end
end
