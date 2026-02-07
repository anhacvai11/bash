sudo apt update -y
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock
docker pull traffmonetizer/cli_v2
ips=$(hostname -I | egrep -io '10.[0-999].[0-999].[0-999]*')
number=0
number1=0
number2=0
for val in $ips; do docker network create my_network_$number --driver bridge --subnet 192.168.$number1.0/24; ((number1+=1)); ((number+=1)); done
for val in $ips; do sudo iptables -t nat -I POSTROUTING -s 192.168.$number2.0/24 -j SNAT --to-source $val; ((number2+=1)); done
networks=$(docker network ls | egrep -io 'my_network_[0-999]*')
for val in $networks; do docker rm -f tm_$val ps_$val 2>/dev/null; docker run -d --name tm_$val --restart=always --network $val traffmonetizer/cli_v2 start accept --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=; done
for val in $(docker network ls | egrep -io 'my_network_[0-9]*'); do docker run -d --platform linux/amd64 --name urnetwork_$val --network $val --restart=always --pull=always --privileged --memory=100m --memory-swap=100m --log-driver=json-file --log-opt max-size=5m --log-opt max-file=3 -e USER_AUTH="anhkhoavipp@gmail.com" -e PASSWORD="Anhnguyen11@" -e ENABLE_IP_CHECKER=false -v vnstat_$val:/var/lib/vnstat tuanna9414/urnetwork:latest; done



