#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock
docker run -d --restart always traffmonetizer/cli_v2 start accept --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=
docker run -d --restart=always packetshare/packetshare -accept-tos -email=anhkhoavipp@gmail.com -password=Anhnguyen11
fi
