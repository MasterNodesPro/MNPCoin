#!/bin/bash

now=$(date +"%m_%d_%Y")

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

echo && echo "going to root directory"
cd ~/

echo && echo "Stopping daemon..."
mnpcoin-cli stop

echo && echo "downloading update"
wget https://github.com/MasterNodesPro/MNPCoin/releases/download/v1.1.0/mnpcoin-linux-ubuntu1604-v1.1.0.zip -O mnpcoin-v1.1.0.zip

mkdir mnpcoinbackup
cd mnpcoinbackup
mkdir $now

backuppath=~/mnpcoinbackup/$now

echo && echo "backing up wallet.dat masternode.conf mnpcoin.conf to $(backuppath)"
cd ../.mnpcoin
cp wallet.dat $backuppath
cp masternode.conf $backuppath
cp mnpcoin.conf $backuppath

cd ~/

echo && echo "unzipping daemons"
unzip mnpcoin-v1.1.0.zip -d ~/mnpcoin-release
cd mnpcoin-release
chmod +x mnpcoind
chmod +x mnpcoin-cli
chmod +x mnpcoin-tx
chmod +x mnpcoin-qt

echo && echo "moving to /usr/bin"
sudo mv mnpcoin-cli /usr/bin/mnpcoin-cli
sudo mv mnpcoin-tx /usr/bin/mnpcoin-tx
sudo mv mnpcoind /usr/bin/mnpcoind
sudo mv mnpcoin-qt /usr/bin/mnpcoin-qt

echo && echo "cleaning up"
cd ~/
rm mnpcoin-release -rf
rm mnpcoin-v1.1.0.zip

echo && echo "starting daemon"
mnpcoind
