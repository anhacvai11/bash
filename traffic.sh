#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock
docker run -it -d --name traffmonetizer --restart always --memory=100mb traffmonetizer/cli_v2 start accept --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=
docker run -d --name earnfm --restart=always --memory=100mb -e EARNFM_TOKEN="c9039985-a294-47dd-a154-56993d4b7a7e" earnfm/earnfm-client:latest
fi
