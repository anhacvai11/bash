#!/bin/bash
sudo apt update && sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo apt install -y ./cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt -y install cuda-toolkit-11-8
sudo apt update
sudo apt -y full-upgrade 

done
