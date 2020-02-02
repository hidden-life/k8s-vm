# -*- mode: ruby -*-
# vi: set ft=ruby

IMG_NAME = "centos/7"
NODES_NUM = 2

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
    config.ssh.insert_key = false
    config.vm.provision "shell", path: "install.sh"
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.define "kube-master" do |master|
        master.vm.box = IMG_NAME
        master.vm.hostname = "master.node"
        master.vm.network "private_network", ip: "172.42.42.100"
        master.vm.provider "libvirt" do |v|
            v.memory = 2048
            v.cpus = 2
        end
        master.vm.provision "shell", path: "init-master.sh"
    end

    (1..NODES_NUM).each do |i|
        config.vm.define "kube-node-#{i}" do |worker|
            worker.vm.box = IMG_NAME
            worker.vm.hostname = "worker#{i}.node"
            worker.vm.network "private_network", ip: "172.42.42.10#{i}"
            worker.vm.provider "libvirt" do |v|
                v.memory = 1024
                v.cpus = 1
            end
            worker.vm.provision "shell", path: "init-worker.sh"
        end
    end

end