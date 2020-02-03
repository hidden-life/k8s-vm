#!/bin/bash

# Init worker
echo "--- [ WORKER NODE INITIALIZE ] ---"

echo "[TASK 1 - Join Node to Master Node]"
yum install -y -q sshpass > /dev/null 2>&1
sshpass -p "rootpassword" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.node:/join_cluster.sh /join_cluster.sh
bash /join_cluster.sh
echo "[TASK 1 - Finished]"