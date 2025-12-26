#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock
for val in $networks; do docker rm -f tm_$val ps_$val 2>/dev/null; docker run -d --name tm_$val --restart=always --network $val traffmonetizer/cli_v2 start accept --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=; docker run -d --name ps_$val --restart=always --network $val packetshare/packetshare -accept-tos -email=anhacvai123@gmail.com -password=Anhnguyen11; done
for val in $(docker network ls | egrep -io 'my_network_[0-9]*'); do docker run -d --name earnfm_$val --restart=always --network $val --memory=100mb -e EARNFM_TOKEN="c9039985-a294-47dd-a154-56993d4b7a7e" earnfm/earnfm-client:latest; done
fi
