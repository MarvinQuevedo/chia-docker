# Chia Wallet docker

## Build

First, copy the ssl files to ./ssl

docker build . -t chia --build-arg words="mnemonics words"

## Run

docker run -it chia -p 8556:8555  -p 8450:8449  

## CLI commands

### Add cat token

docker exec -it chia venv/bin/chia wallet add_token -id "aa53978aaac154e32380aaf6322cd316696442248f1d15051007bc48b011694b" -n "CTK"

### show Wallet

docker exec -it chia venv/bin/chia wallet show
