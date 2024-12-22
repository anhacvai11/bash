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

# 2. Sau mỗi lần khởi động, thiết lập và chạy lolMiner
echo "Khởi động lại hệ thống. Thiết lập và chạy lolMiner..."

# Đảm bảo lolMiner tồn tại
cd /home/$(whoami)
if [ ! -d "lolMiner_Linux" ]; then
    echo "lolMiner chưa tồn tại. Tải và giải nén..."
    wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.76a/lolMiner_v1.76a_Lin64.tar.gz
    tar -xvf lolMiner_v1.76a_Lin64.tar.gz
    mv 1.76a lolMiner_Linux
    chmod +x lolMiner_Linux/lolMiner
fi

# Chạy lolMiner
cd lolMiner_Linux
./lolMiner --algo karlsenhashv2 --pool stratum+tcp://kls.2miners.com:2020 --user kls:qpezc8kp99fx3eqkvsv5l92mqr4960yr6837fzrfwr8gwf8cv7sku5c9wdzkj.myWorker &
echo "lolMiner đã được khởi động với thuật toán karlsenhashv2."
