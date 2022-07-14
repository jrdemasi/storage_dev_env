#!/usr/bin/env bash

apt update 
apt install -y git ansible # ensure we have git to clone our repo and let ansible take over
cd /root
git glone https://github.com/jrdemasi/storage_dev_env # repo contains playbooks
