#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock
docker run -d --restart always traffmonetizer/cli_v2 start accept --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=
docker run -d --restart=always packetshare/packetshare -accept-tos -email=anhkhoavipp@gmail.com -password=Anhnguyen11
docker run --name repocket -e RP_EMAIL=anhkhoavipp@gmail.com -e RP_API_KEY=70fde55f-bfa5-4dd8-a6ce-f089a996f608 -d --restart=always repocket/repocket
fi
