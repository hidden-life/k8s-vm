#!/bin/bash

# Init k8s
echo "--- Starting Master Node initialize ---"
echo "--- [TASK 1] Initialize kubernetes cluster---"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2> /dev/null
echo "--- [TASK 1] Finished ---"

echo "--- [TASK 2] Copy admin configuration ---"
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
echo "--- [TASK 2] Finished ---"

echo "--- [TASK 3] Deploy Calico network---"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml"
echo "--- [TASK 3] Finished ---"

echo "--- [TASK 4] Generate join command ---"
kubeadm token create --print-join-command > /join_cluster.sh
echo "--- [TASK 4] Finished ---"