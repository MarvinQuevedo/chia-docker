# Chia Wallet docker

## persistent volume

docker volume create chia_wallet1_vol

## Build

First, copy the ssl files to ./ssl

docker build . -t chia_wallet1   --build-arg words="mnemonics words"

## Run

### create permanent files

.chia_wallet/mainnet

### run docker

docker run -d --name chia_wallet1  -p 8556:8555  -p 8450:8449  -v ~/.chia_wallet/mainnet:/root/.chia/mainnet  chia_wallet1

## CLI commands

### Add cat token

docker exec -it chia_wallet1 chia wallet add_token -id "aa53978aaac154e32380aaf6322cd316696442248f1d15051007bc48b011694b" -n "CTK"

### show Wallet

docker exec -it chia_wallet1 chia wallet show

<!-- docker exec -it chia_wallet1 chia show -a host.docker.internal:8444
docker exec -it chia_wallet1 chia show -a host.docker.internal:58444 -->
