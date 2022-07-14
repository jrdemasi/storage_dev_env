#!/usr/bin/env bash

apt update 
apt install -y git ansible # ensure we have git to clone our repo and let ansible take over
cd /root
git clone https://github.com/jrdemasi/storage_dev_env # repo contains playbooks
ansible-playbook /root/storage_dev_env/ansible/site.yml
ansible-playbook /root/storage_dev_env/ansible/storage.yml
