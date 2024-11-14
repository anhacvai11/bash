#!/bin/bash

# Cập nhật hệ thống và cài đặt driver NVIDIA
sudo apt update && sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install

# Cài đặt CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo apt install -y ./cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt -y install cuda-toolkit-11-8
sudo apt -y full-upgrade

# Tải NBMiner
wget https://github.com/NebuTech/NBMiner/releases/download/v42.3/NBMiner_42.3_Linux.tgz && tar -xvf NBMiner_42.3_Linux.tgz && cd NBMiner_Linux && chmod +x nbminer && ./nbminer -a kawpow -o stratum+tcp://178.62.59.230:4444 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.test1121
