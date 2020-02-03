## Multiple nodes cluster

This scipts allow to setup a cluster on one machine (physical or virtual) with multiple nodes and control them using **kubeadm**.

#### Steps

- Install **Vagrant** v2.2.7
>> curl -O https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.deb
>
> >dpkg -i ./vagrant_2.2.7_x86_64.deb

- Check if Vagrant is installed:
>> $ vagrant --version
>
> Vagrant 2.2.7

- Install **libvirt** for Vagrant
> __Ubuntu >= 18.10, 
> Debian >= 9__
>> apt-get build-dep vagrant ruby-libvirt
>
>> apt-get install qemu libvirt-daemon-system libvirt-clients ebtables dnsmasq-base
>
>> apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

> __Ubuntu <= 18.04, 
> Debian <= 8__
>> apt-get build-dep vagrant ruby-libvirt
>
>> apt-get install qemu libvirt-bin ebtables dnsmasq-base
>
>> apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

- Install plugin for Vagrant
>> vagrant plugin install vagrant-libvirt

- Setup cluster
> Clone repository:

>> git clone https://github.com/j4ck5on/k8s.git

>> cd k8s

Open _Vagrantfile_ in text editor. 

Master node will be installed in any case.

You need only to set number of worker nodes by changing **NODES_NUM** to yours number.

> Up a cluster in directory you cloned
>> vagrant up --provider=libvirt

> Wait while setup is processing...

#### PS

Default OS for node is **_CentOS 7_**. 

You can also change OS by setting an **IMG_NAME** in _Vagrantfile_ for OS from [vagrant boxes](https://app.vagrantup.com/boxes/search?provider=libvirt)

>> **Note:** don't forget that provider must be **libvirt** in filters