#!/bin/bash

# Init k8s
echo "--- [ MASTER NODE INITIALIZE ] ---"
echo "[TASK 1 - Initialize kubernetes cluster]"
kubeadm init --apiserver-advertise-address=192.168.50.200 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2> /dev/null
echo "[TASK 1 - Finished]"

echo "[TASK 2 - Copy configuration]"
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
echo "[TASK 2 - Finished]"

echo "[TASK 3 - Deploy Flannel network]"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml"
echo "[TASK 3 - Finished]"

echo "[TASK 4 - Generate join command]"
kubeadm token create --print-join-command > /join_cluster.sh
echo "[TASK 4 - Finished]"