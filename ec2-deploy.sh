#!/bin/bash

# AWS CLI
if [[ -f ./awscliv2.zip ]]
then
  sudo rm ./awscliv2.zip
fi
if [[ -d ./aws ]]
then
  sudo rm -r ./aws
fi
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Docker engine
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
if [[ -d /etc/apt/keyrings ]]
then
  sudo rm -r /etc/apt/keyrings
fi
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get install -y docker-compose
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER

exec $SHELL
