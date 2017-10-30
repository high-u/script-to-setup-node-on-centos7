#!/bin/bash
set -e

NVM_VERSION="v0.33.6"

cd ~
sudo yum update
sudo yum -y upgrade
sudo yum -y install git vim gcc-c++ make wget

# install node
curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash
shopt -s expand_aliases
source ~/.bashrc
nvm ls-remote
read -p "node version: " nv
nvm install ${nv}
nvm use ${nv}
nvm alias default ${nv}
npm install -g pm2

# install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
yum list docker-ce.x86_64 --showduplicates
read -p "docker version: " dv
sudo yum install docker-ce-${dv}
sudo systemctl enable docker
sudo systemctl start docker

# install node-red
mkdir ~/node-red
cd ~/node-red
mkdir ./node_modules
#npm install --save node-red@0.15.3
npm install --save node-red

nvm --version
node -v
npm -v
docker --version
node ~/node-red/node_modules/node-red/red.js --help
echo "pm2 start ~/node_modules/node-red/red.js -u ~/node-red/user-dir -p 1880"

# reboot
read -p 'RUN `sudo reboot`: '
sudo reboot

