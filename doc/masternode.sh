#!/bin/bash

PACKAGE='mnpcoin-v1.2.5.tar.gz'
VERSION='v1.2.5'

system_motd() {
    clear
    cd /root
    echo && echo
    echo "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗    ████████╗ ██████╗ "
    echo "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝    ╚══██╔══╝██╔═══██╗"
    echo "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗         ██║   ██║   ██║"
    echo "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝         ██║   ██║   ██║"
    echo "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗       ██║   ╚██████╔╝"
    echo " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝       ╚═╝    ╚═════╝ "
    echo "                                                                                    "
    echo "            ███╗   ███╗███╗  ██╗ █████╗  ██████╗ ██████╗ ██╗███╗  ██╗               "
    echo "            ████╗ ████║████╗ ██║██╔══██╗██╔════╝██╔═══██╗██║████╗ ██║               "
    echo "            ██╔████╔██║██╔█████║███████║██║     ██║   ██║██║██╔█████║               "
    echo "            ██║╚██╔╝██║██║╚████║██╔════╝██║     ██║   ██║██║██║╚████║               "
    echo "            ██║ ╚═╝ ██║██║ ╚═██║██║     ╚██████╗╚██████╔╝██║██║ ╚═██║               "
    echo "            ╚═╝     ╚═╝╚═╝   ╚═╝╚═╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝   ╚═╝               "
    echo ""
    echo "Updated: 2/25/2019 By: MNP_Jason"
    echo && echo && echo
    sleep 2
}

# Print usage
usage() {
  echo -n "./masternodes.sh [OPTION]
 Options:
  -s, -setup    Setup your masternode for the first time
  -u, -update   Update your masternode to the newest scripts
  -h, -help     You're Reading This
"
}

is_root() {
    # Check if is root
    if [ "$(whoami)" != "root" ]; then
      echo "Script must be run as user: root"
      exit -1
    fi
}

is_ubuntuXenial() {
    # Check for systemd
    systemctl --version >/dev/null 2>&1 || { echo "You must use Ubuntu 16.04 (Xenial)."  >&2; exit 1; }
}

get_UserMasterNodeData() {
    # Gather input from user
    echo "Please enter your Masternode Private Key"
    read -e -p "e.g. (8tagsuahsAHAJshjvhs88asadijsuyas98aqsaziucdplmkh75sb) : " key
    if [[ "$key" == "" ]]; then
        echo "WARNING: No private key entered, exiting!!!"
        echo && exit
    fi
    read -e -p "VPS Server IP Address and Masternode RPC Port like IP:11000 : " ip
    echo && echo "Pressing ENTER will use the default value for the next prompts."
    echo && sleep 3
    read -e -p "Add swap space? (Recommended) [Y/n] : " add_swap
    if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
        read -e -p "Swap Size [2G] : " swap_size
        if [[ "$swap_size" == "" ]]; then
            swap_size="2G"
        fi
    fi
    read -e -p "Install Fail2ban? (Recommended) [Y/n] : " install_fail2ban
}

add_swap() {
    # Add swap if needed
    if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
        if [ ! -f /swapfile ]; then
            echo && echo "Adding swap space..."
            sleep 3
            sudo fallocate -l $swap_size /swapfile
            sudo chmod 600 /swapfile
            sudo mkswap /swapfile
            sudo swapon /swapfile
            echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
            sudo sysctl vm.swappiness=10
            sudo sysctl vm.vfs_cache_pressure=50
            echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
            echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
        else
            echo && echo "WARNING: Swap file detected, skipping add swap!"
            sleep 3
        fi
    fi
}

update_system() {
    # Update system
    echo && echo "Upgrading system and install initial dependencies"
    sleep 3
    sudo apt -y update
    sudo apt -y upgrade
}

install_requied() {
    # Install required packages
    echo && echo "Installing base packages..."
    sleep 3
    sudo apt -y install \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    unzip \
    pkg-config \
    libssl-dev \
    bsdmainutils \
    software-properties-common \
    libzmq3-dev \
    libevent-dev \
    libboost-dev \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libdb4.8-dev \
    libdb4.8++-dev \
    libminiupnpc-dev \
    python-virtualenv

    # Install fail2ban if needed
    if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
        echo && echo "Installing fail2ban..."
        sleep 3
        sudo apt -y install fail2ban
        sudo service fail2ban restart
    fi
}

create_MNPCoin_Folder() {
    # Edit/Create config file for MNPCoin
    echo && echo "Creating your data folder and files..."
    sleep 3
    sudo mkdir /root/.mnpcoin

    rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    sudo touch /root/.mnpcoin/mnpcoin.conf
    echo '
    rpcuser='$rpcuser'
    rpcpassword='$rpcpassword'
    rpcallowip=127.0.0.1
    listen=1
    server=1
    rpcport=11000
    daemon=1
    logtimestamps=1
    maxconnections=256
    externalip='$ip'
    masternode=1
    masternodeprivkey='$key'
    ' | sudo -E tee /root/.mnpcoin/mnpcoin.conf
}

download_install_MNPCoin() {
    # Download binaries for Linux
    mkdir mnpcoin
    wget https://github.com/MasterNodesPro/MNPCoin/releases/download/$VERSION/$PACKAGE -O $PACKAGE
    #unzip ${PACKAGE} -D mnpcoin
    tar xzvf $PACKAGE -C mnpcoin
    cd mnpcoin
    # Give permissions, move to bin folder and run
    chmod +x mnpcoind
    chmod +x mnpcoin-cli
    chmod +x mnpcoin-tx

    # Move binaries do lib folder
    sudo mv mnpcoin-cli /usr/local/bin/mnpcoin-cli
    sudo mv mnpcoin-tx /usr/local/bin/mnpcoin-tx
    sudo mv mnpcoind /usr/local/bin/mnpcoind
}

run_mnpcoind() {
    #run daemon
    mnpcoind -daemon
    sleep 5
}

stop_mnpcoind() {
    echo && echo "Stopping mnpcoin"
    mnpcoin-cli stop
}

start_masternode() {
    mnpcoin-cli startmasternode local false
    sleep 5
}

create_cronjob() {
    # Create a cronjob for making sure mnpcoind runs after reboot
    if ! crontab -l | grep "@reboot mnpcoind -daemon"; then
      (crontab -l ; echo "@reboot mnpcoind -daemon") | crontab -
    fi
}

system_complete() {
    # Finished
    echo && echo "MNPCoin Masternode Setup Complete!"

    echo "If you put correct PrivKey and VPS IP the daemon should be running."
    echo "Wait 2 minutes then run mnpcoin-cli getinfo to check blocks."
    echo "When fully synced you can start ALIAS on local wallet and finally check here with mnpcoin-cli masternode status."
    echo && echo
}

run_setup() {
    is_root
    is_ubuntuXenial
    system_motd
    echo "Now running First Time MasterNode Setup"
    stop_mnpcoind
    get_UserMasterNodeData
    add_swap
    update_system
    install_requied
    create_MNPCoin_Folder
    download_install_MNPCoin
    run_mnpcoind
    start_masternode
    create_cronjob
    system_complete
}

run_update() {
    is_root
    is_ubuntuXenial
    system_motd
    echo "Now running MasterNode Update"
    stop_mnpcoind
    update_system
    download_install_MNPCoin
    run_mnpcoind
    start_masternode
    system_complete
}

while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; exit -1 ;;
    -s|--setup) run_setup >&2; exit -1 ;;
    -u|--update) run_update >&2; exit -1 ;;
  esac
  shift
done

run_setup >&2

exit -1
