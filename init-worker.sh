#!/bin/bash

# Init worker
echo "--- Starting worker node with join to master node ---"

echo "--- [TASK 1] Join Worker Node to Master Node ---"
yum install -y -q sshpass > /dev/null 2>&1
sshpass -p "rootpassword" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.node:/join_cluster.sh /join_cluster.sh
bash /join_cluster.sh
echo "--- [TASK 1] Finished ---"