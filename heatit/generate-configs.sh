#!/bin/bash

./heatit process -s ./cloud-config.template.yml -p ./params.yml -d manager.yml --param-override=node-role=manager
echo -e "#cloud-config\n$(cat manager.yml)" > manager.yml

./heatit process -s ./cloud-config.template.yml -p ./params.yml -d worker.yml --param-override=node-role=worker
echo -e "#cloud-config\n$(cat worker.yml)" > worker.yml

./heatit process -s ./ignition.template.yml -p ./params.yml -d manager-ignition.yml --param-override=node-role=manager
ct -in-file manager-ignition.yml -out-file manager-ignition.ign

./heatit process -s ./ignition.template.yml -p ./params.yml -d worker-ignition.yml --param-override=node-role=worker
ct -in-file worker-ignition.yml -out-file worker-ignition.ign

cp manager-ignition.ign /home/lars/admin/docker-infrastructure/roles/vms/files/provision.ign

cd /home/lars/admin/docker-infrastructure
git add /home/lars/admin/docker-infrastructure/roles/vms/files/provision.ign
git commit
git push
