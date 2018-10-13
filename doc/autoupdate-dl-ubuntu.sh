#!/bin/bash

now=$(date +"%m_%d_%Y")

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

apt install libzmq3-dev -y

echo && echo "going to root directory"
cd ~/

echo && echo "Stopping daemon..."
mnpcoin-cli stop

echo && echo "downloading update"
wget https://github.com/MasterNodesPro/MNPCoin/releases/download/v1.2.0/mnpcoin-1.2.0-ubuntu-no-gui.tar.gz -O mnpcoin-v1.2.0.tar.gz

mkdir mnpcoinbackup && cd $_

mkdir $now

backuppath=~/mnpcoinbackup/$now

echo && echo "backing up wallet.dat masternode.conf mnpcoin.conf to ${backuppath}"
cd ../.mnpcoin
cp wallet.dat $backuppath
cp masternode.conf $backuppath
cp mnpcoin.conf $backuppath

cd ~/

echo && echo "unzipping daemons"
mkdir mnpcoin-release
tar zxvf mnpcoin-v1.2.0.tar.gz -C ~/mnpcoin-release
cd mnpcoin-release
chmod +x mnpcoind
chmod +x mnpcoin-cli
chmod +x mnpcoin-tx

echo && echo "moving to /usr/bin"
sudo mv mnpcoin-cli /usr/local/bin/mnpcoin-cli
sudo mv mnpcoin-tx /usr/local/bin/mnpcoin-tx
sudo mv mnpcoind /usr/local/bin/mnpcoind

echo && echo "cleaning up"
cd ~/
rm mnpcoin-release -rf
rm mnpcoin-v1.2.0.tar.gz

echo && echo "starting daemon"
mnpcoind