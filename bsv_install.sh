#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

echo "Installing BitcoinSV Docker"

mkdir -p $HOME/.bsvdocker

echo "Initial BitcoinSV Configuration"

read -p 'rpcuser: ' rpcuser
read -p 'rpcpassword: ' rpcpassword

echo "Creating BitcoinSV configuration at $HOME/.bsvdocker/bitcoin.conf"

cat >$HOME/.bsvdocker/bitcoin.conf <<EOL
server=1
listen=1
rpcuser=$rpcuser
rpcpassword=$rpcpassword
rpcport=8532
rpcthreads=4
dbcache=8000
par=0
port=8533
rpcallowip=127.0.0.1
rpcallowip=$(curl -s https://canihazip.com/s)
usecashaddr=0
EOL

echo Installing BitcoinSV Container

docker volume create --name=bsv-data
docker run -v bsv-data:/bitcoinsv --name=bsvd-node -d \
      -p 8933:8933 \
      -p 8932:8932 \
      -v $HOME/.bsvdocker/bitcoin.conf:/bitcoinsv/.bitcoin/bitcoin.conf \
      bitsler/docker-bitcoinsv:latest

echo "Creating shell script"

cat >/usr/bin/bsv-cli <<'EOL'
#!/usr/bin/env bash
docker exec -it bsvd-node /bin/bash -c "bitcoin-cli $*"
EOL

cat >/usr/bin/bsv-update <<'EOL'
#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi
echo "Updating bsv..."
sudo docker stop bsvd-node
sudo docker rm bsvd-node
sudo docker pull bitsler/docker-bitcoinsv:latest
docker run -v bsv-data:/bitcoinsv --name=bsvd-node -d \
      -p 8933:8933 \
      -p 8932:8932 \
      -v $HOME/.bsvdocker/bitcoin.conf:/bitcoinsv/.bitcoin/bitcoin.conf \
      bitsler/docker-bitcoinsv:latest
EOL

cat >/usr/bin/bsv-rm <<'EOL'
#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi
echo "WARNING! This will delete ALL bsv-docker installation and files"
echo "Make sure your wallet.dat is safely backed up, there is no way to recover it!"
function uninstall() {
  sudo docker stop bsvd-node
  sudo docker rm bsvd-node
  sudo rm -rf ~/docker/volumes/bsv-data ~/.bsvdocker /usr/bin/bsv-cli
  sudo docker volume rm bsv-data
  echo "Successfully removed"
  sudo rm -- "$0"
}
read -p "Continue (Y)?" choice
case "$choice" in
  y|Y ) uninstall;;
  * ) exit;;
esac
EOL

chmod +x /usr/bin/bsv-cli
chmod +x /usr/bin/bsv-rm
chmod +x /usr/bin/bsv-update

echo
echo "==========================="
echo "==========================="
echo "Installation Complete"
echo "You can now run normal bchd-cli commands"
echo "Your configuration file is at $HOME/.bsvdocker/bitcoin.conf"
echo "If you wish to change it, make sure to restart bsvd-node"
echo "IMPORTANT: To stop bsvd-node gracefully, use 'bsv-cli stop' and wait for the container to stop to avoid corruption"