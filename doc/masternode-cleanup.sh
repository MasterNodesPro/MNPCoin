#/bin/bash

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

echo && echo "Stopping mnpcoin"
mnpcoin-cli stop

echo && echo "moving mnpcoin executables to another directory"
mv /usr/bin/mnpcoind /usr/local/bin/mnpcoind
mv /usr/bin/mnpcoin-tx /usr/local/bin/mnpcoin-tx
mv /usr/bin/mnpcoin-cli /usr/local/bin/mnpcoin-cli

echo && echo "starting mnpcoind"
mnpcoind