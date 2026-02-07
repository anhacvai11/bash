sudo apt update -y
sudo apt install docker.io -y
sudo chmod 777 /var/run/docker.sock

docker pull traffmonetizer/cli_v2
docker pull tuanna9414/urnetwork:latest

# Tạo 1 docker network duy nhất
docker network rm my_network 2>/dev/null
docker network create my_network --driver bridge --subnet 192.168.100.0/24

# Xoá container cũ (nếu có)
docker rm -f tm ps urnetwork 2>/dev/null

# TraffMonetizer
docker run -d \
  --name tm \
  --restart=always \
  --network my_network \
  traffmonetizer/cli_v2 start accept \
  --token mtbdZVJjiFHpPQgYEry9xD5kMLSShtHGWbctwdkZsMc=

# UrNetwork
docker run -d \
  --platform linux/amd64 \
  --name urnetwork \
  --network my_network \
  --restart=always \
  --privileged \
  --memory=100m \
  --memory-swap=100m \
  --log-driver=json-file \
  --log-opt max-size=5m \
  --log-opt max-file=3 \
  -e USER_AUTH="anhkhoavipp@gmail.com" \
  -e PASSWORD="Anhnguyen11@" \
  -e ENABLE_IP_CHECKER=false \
  -v vnstat:/var/lib/vnstat \
  tuanna9414/urnetwork:latest
