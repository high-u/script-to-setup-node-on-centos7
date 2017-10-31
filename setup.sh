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
read -p "node version (ex. v8.8.1): " nv
nvm install ${nv}
nvm use ${nv}
nvm alias default ${nv}
npm install -g pm2

# install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
yum list docker-ce.x86_64 --showduplicates
read -p "docker version (ex. 17.09.0.ce-1.el7.centos): " dv
sudo yum install -y docker-ce-${dv}
sudo systemctl enable docker
sudo systemctl start docker

#  install node-red
mkdir -p ~/node-red
cd ~/node-red
mkdir -p ~/node-red/user-settings
mkdir -p ~/node-red/node_modules
#npm install --save node-red@0.15.3
npm install --save node-red

echo "nvm "$(nvm --version)
echo "node "$(node -v)
echo "npm "$(npm -v)
echo "docker "$(docker --version)
node ~/node-red/node_modules/node-red/red.js --help
echo ""
echo -e 'ex. \e[44m pm2 start ~/node-red/node_modules/node-red/red.js -u ~/node-red/user-settings -p 1880 \e[m'
echo ""

# output message
echo -e 'RUN \e[46m sudo reboot \e[m or \e[46m source ~/.bashrc \e[m'
echo ""
echo "success"
exit 0
