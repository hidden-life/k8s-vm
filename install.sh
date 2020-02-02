#!/bin/bash

# Update nodes hosts
echo "--- [TASK 1] Updating /etc/hosts file ---"
cat >> /etc/hosts <<EOF
172.42.42.100   master.node     master
172.42.42.101   worker1.node    worker1
172.42.42.102   worker2.node    worker2
EOF
echo "--- [TASK 1] Finished ---"

# Install docker
echo "--- [TASK 2] Install docker ---"
echo "---> Install required packages ---"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
echo "---> Setup stable repository for this OS ---"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
echo "---> Installing docker ---"
yum install -y -q docker-ce docker-ce-cli containerd.io > /dev/null 2>&1
echo "---> Enabling docker ---"
systemctl enable docker
echo "---> Start docker ---"
systemctl start docker
echo "--- [TASK 2] Finished ---"

# Disable SELinux and Firewall
echo "--- [TASK 3] Disable SELinux & firewall ---"
echo "---> Disabling SELinux ---"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
echo "---> Disabling firewall ---"
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld
echo "--- [TASK 3] Finished ---"

# Add sysctl settings
echo "--- [TASK 4] Add sysctl settings ---"
cat >> /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system > /dev/null 2>&1
echo "--- [TASK 4] Finished ---"

# Swap off
echo "--- [TASK 5] Disable and turn off SWAP  ---"
sed -i '/swap/d' /etc/fstab
swapoff -a
echo "--- [TASK 5] Finished ---"

# K8s repository
echo "--- [TASK 6] Add kubernetes repository ---"
cat >> /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
echo "--- [TASK 6] Finished ---"

# Install k8s
echo "--- [TASK 7] Install kubernetes (kubeadm, kubectl, kubelet) ---"
yum install -y -q kubeadm kubelet kubectl > /dev/null 2>&1
echo "--- [TASK 7] Finished ---"

# Enable service
echo "--- [TASK 8] Enable and start kubelet service ---"
echo "---> Enabling kubelet ---"
systemctl enable kubelet > /dev/null 2>&1
echo "---> Starting kubelet ---"
systemctl start kubelet > /dev/null 2>&1
echo "--- [TASK 8] Finished ---"

# Enable SSH
echo "--- [TASK 9] Enable SSH password authentication ---"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "---> Reloading SSH ---"
systemctl reload sshd
echo "--- [TASK 9] Finished ---"

# Set password 'rootpassword'
echo "--- [TASK 10] Setting password for root access ---"
echo "rootpassword" | passwd --stdin root > /dev/null 2>&1
echo "---> Updating bashrc users file ---"
echo "export TERM=xterm" >> /etc/bashrc
echo "--- [TASK 10] Finished ---"
