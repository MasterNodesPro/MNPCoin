# How to Mine MNPCoin

* Build Linux QT or Command Line Wallet
https://github.com/MasterNodesPro/MNPCoin/blob/master/doc/build-unix.md

* Run `mnpcoind` and then press ctrl+c to kill the process. This will create the hidden folder and required files for you. Now `cd .mnpcoin` and edit the `mnpcoin.conf`

* Edit your `~/.mnpcoin/mnpcoin.conf` to look like this

```
#Standard
daemon=1
server=1
txindex=1
staking=1
maxconnections=255

#RPC
rpcusername=mnpcoinrpc
rpcpassword= **** CHANGE THIS PASSWORD it can be anything ****
rpcport=33221
rpcallowip=127.0.0.1
```
* Run the daemon with `mnpcoind`

#### _**If you are on a Vultr VPS with only 1 core be careful mining because this will keep the CPU usage at 100% for an extended amount of time and can result in the VPS being shut down because of breach of TOS**_

* To start the miner if you have more than one core you just append the number of cores you want to use to the end of the command

* `mnpcoin-cli setgenerate true 3` will use 3 cores. I don’t recommend using all cores on a server from vultr.

* If you have a multicore desktop you could set up a virtualbox to run linux and give it access to more than one core and then mine using that, but it will hurt performance of your desktop.