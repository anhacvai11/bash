#!/bin/bash

# Hàm cập nhật biến môi trường và khởi động lại container Docker
update_and_restart() {
    new_pool_url=$(curl -s https://raw.githubusercontent.com/max313iq/Ssl/main/ip) # Thay đổi URL theo pool của bạn
    if [ "$new_pool_url" != "$POOL_URL" ]; then
        echo "Updating POOL_URL to: $new_pool_url"
        export POOL_URL=$new_pool_url
        sudo docker stop $(sudo docker ps -q --filter ancestor=your_miner_image_name) # Thay 'your_miner_image_name' bằng tên image của bạn
        sudo docker run -d -e WALLET="$WALLET_ADDRESS" -e POOL="$POOL_URL" --name rvn-miner your_miner_image_name # Thay 'your_miner_image_name' bằng tên image của bạn
    else
        echo "No updates found."
    fi
}

# Cài đặt Docker
install_docker() {
    sudo apt-get update --fix-missing
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update --fix-missing
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

# Địa chỉ ví và pool khai thác
WALLET_ADDRESS="RCHgrFpTR6viTwShmratMsZAwenRNYYRao"  # Thay bằng địa chỉ ví RVN của bạn
POOL_URL="46.101.160.28:3333"  # Thay bằng địa chỉ pool khai thác bạn muốn sử dụng

# Kiểm tra và cài đặt Docker
if ! command -v docker &> /dev/null
then
    echo "Docker chưa được cài đặt. Đang cài đặt Docker..."
    install_docker
else
    echo "Docker đã được cài đặt."
fi

# Chạy Docker container với POOL_URL ban đầu
export POOL_URL="$POOL_URL"
sudo docker run -d -e WALLET="$WALLET_ADDRESS" -e POOL="$POOL_URL" --name rvn-miner apolikamixitos/2miners-gn # Thay 'your_miner_image_name' bằng tên image của bạn

# Đợi một chút trước khi vào vòng lặp kiểm tra
sleep 10

# Vòng lặp kiểm tra liên tục
while true; do
    sleep 1200  # Kiểm tra mỗi 20 phút
    update_and_restart
done
