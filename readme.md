# Chia Wallet docker

## Build

docker build . -t chia --build-arg words="mnemonics words"

## Run

docker run -it chia -p 127.0.0.1:8556:8555  -p 127.0.0.1:8450:8449 -p 127.0.0.1:55401:55400
