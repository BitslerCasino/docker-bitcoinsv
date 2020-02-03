# docker-bitcoinsv
Docker Image for Bitcoin SV using Bitcoin-sv Client

### Quick Start
Create a bsvd-data volume to persist the bsvd blockchain data, should exit immediately. The bsvd-data container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):
```
docker volume create --name=bsvd-data
```
Create a bitcoin.conf file and put your configurations
```
mkdir -p .bsvdocker
nano /home/$USER/.bsvdocker/bitcoin.conf
```

Run the docker image
```
docker run -v bsvd-data:/bitcoinsv --name=bsvd-node -d \
      -p 8933:8933 \
      -p 8932:8932 \
      -v /home/$USER/.bsvdocker/bitcoin.conf:/bitcoinsv/.bitcoin/bitcoin.conf \
      unibtc/docker-bitcoinsv
```

Auto Installation
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-bitcoinsv/releases/download/v1.0.0/bsv_install.sh)"
```
Install Utilities
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-bitcoinsv/releases/download/v1.0.0/bsv_utils.sh)"
```
