#!/bin/bash

# Đường dẫn lưu trạng thái
CUDA_FLAG="/var/tmp/cuda_installed"
NBMINER_FLAG="/var/tmp/nbminer_installed"

# 1. Kiểm tra nếu CUDA đã được cài đặt
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

# 2. Sau khi khởi động lại, kiểm tra và tải NBMiner
if [ ! -f "$NBMINER_FLAG" ]; then
    echo "Thiết lập và chạy NBMiner..."
    
    # Tải và giải nén NBMiner
    cd /home/$(whoami)
    wget https://github.com/NebuTech/NBMiner/releases/download/v42.3/NBMiner_42.3_Linux.tgz
    tar -xvf NBMiner_42.3_Linux.tgz
    cd NBMiner_Linux
    chmod +x nbminer

    # Chạy NBMiner
    ./nbminer -a kawpow -o stratum+tcp://178.62.59.230:4444 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.STUDENTS &
    
    # Đánh dấu rằng NBMiner đã được thiết lập
    touch "$NBMINER_FLAG"

    echo "NBMiner đang chạy."
    exit 0
fi

# 3. Nếu cả CUDA và NBMiner đã được cài đặt
echo "Hệ thống đã được cấu hình đầy đủ và NBMiner đang hoạt động."
exit 0
