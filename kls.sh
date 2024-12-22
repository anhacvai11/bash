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

# 2. Sau mỗi lần khởi động, thiết lập và chạy GMiner
echo "Khởi động lại hệ thống. Thiết lập và chạy GMiner..."

# Đảm bảo GMiner tồn tại
cd /home/$(whoami)
if [ ! -d "GMiner_Linux" ]; then
    echo "GMiner chưa tồn tại. Tải và giải nén..."
    wget https://github.com/develsoftware/GMinerRelease/releases/download/3.30/gminer_3_30_linux64.tar.xz
    tar -xvf gminer_3_30_linux64.tar.xz
    mv gminer_3_30_linux64 GMiner_Linux
    chmod +x GMiner_Linux/miner
fi

# Chạy GMiner
cd GMiner_Linux
./miner --algo kaspa --server stratum+tcp://kas.2miners.com:2020 --user kaspa:your_kaspa_wallet_address.myWorker &
echo "GMiner đã được khởi động."
