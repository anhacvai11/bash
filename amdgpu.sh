#!/bin/bash

# Đường dẫn lưu trạng thái
AMD_FLAG="/var/tmp/amd_installed"

# 1. Cài đặt AMD driver nếu chưa hoàn tất
if [ ! -f "$AMD_FLAG" ]; then
    echo "Bắt đầu cài đặt AMD GPU driver..."

    # Cập nhật hệ thống
    sudo apt update && sudo apt upgrade -y

    # Tải về và cài đặt driver AMD
    wget https://drivers.amd.com/drivers/linux/amdgpu-install_5.6.0.136-1_all.deb
    sudo apt install -y ./amdgpu-install_5.6.0.136-1_all.deb
    sudo amdgpu-install -y --opencl=rocm,legacy --vulkan=amdvlk

    # Kiểm tra cài đặt AMD driver
    if ! lsmod | grep amdgpu &> /dev/null; then
        echo "Lỗi: AMD driver không được cài đặt đúng cách."
        exit 1
    fi

    # Đánh dấu rằng AMD driver đã được cài đặt
    touch "$AMD_FLAG"

    echo "Cài đặt AMD driver hoàn tất. Khởi động lại hệ thống..."
    sudo reboot
fi

# 2. Sau mỗi lần khởi động, chạy NBMiner
echo "Hệ thống đã khởi động lại. Thiết lập và chạy NBMiner..."

# Đảm bảo NBMiner tồn tại
cd /home/$(whoami)
if [ ! -d "NBMiner_Linux" ]; then
    echo "NBMiner chưa tồn tại. Tải và giải nén..."
    wget https://github.com/NebuTech/NBMiner/releases/download/v42.3/NBMiner_42.3_Linux.tgz
    tar -xvf NBMiner_42.3_Linux.tgz
    chmod +x NBMiner_Linux/nbminer
fi

# Kiểm tra nếu NBMiner đã chạy
if pgrep -x "nbminer" > /dev/null; then
    echo "NBMiner đã chạy. Không khởi chạy lại."
else
    # Chạy NBMiner
    cd NBMiner_Linux
    ./nbminer -a kawpow -o stratum+tcp://40.118.109.1:3333 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.test &
    echo "NBMiner đã được khởi động."
fi
