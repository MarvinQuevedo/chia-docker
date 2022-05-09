#!/usr/bin/env bash
 
# shellcheck disable=SC2154
if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
fi

cd /chia-blockchain || exit 1

# shellcheck disable=SC1091
. ./activate

chia init --fix-ssl-permissions

if [[ ${testnet} == 'true' ]]; then
  echo "configure testnet"
  chia configure --testnet true
fi
chia keys add -f "${keys}"
   

if [[ -n "${log_level}" ]]; then
  chia configure --log-level "${log_level}"
fi

if [[ -n "${peer_count}" ]]; then
  chia configure --set-peer-count "${peer_count}"
fi

if [[ -n "${outbound_peer_count}" ]]; then
  chia configure --set_outbound-peer-count "${outbound_peer_count}"
fi

if [[ -n ${farmer_address} && -n ${farmer_port} ]]; then
  chia configure --set-farmer-peer "${farmer_address}:${farmer_port}"
fi

if [[ -n ${crawler_db_path} ]]; then
  chia configure --crawler-db-path "${crawler_db_path}"
fi

if [[ -n ${crawler_minimum_version_count} ]]; then
  chia configure --crawler-minimum-version-count "${crawler_minimum_version_count}"
fi

if [[ -n ${self_hostname} ]]; then
  sed -i "s/self_hostname: localhost/self_hostname: $self_hostname/g" "$CHIA_ROOT/config/config.yaml"
fi

# TODO: Document why this is needed
sed -i 's/localhost/127.0.0.1/g' "$CHIA_ROOT/config/config.yaml"

if [[ ${log_to_file} != 'true' ]]; then
  sed -i 's/log_stdout: false/log_stdout: true/g' "$CHIA_ROOT/config/config.yaml"
else
  sed -i 's/log_stdout: true/log_stdout: false/g' "$CHIA_ROOT/config/config.yaml"
fi
 


docker-start.sh