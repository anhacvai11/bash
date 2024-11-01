#!/bin/bash
sudo apt update && sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo apt install -y ./cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt -y install cuda-toolkit-12-5
# chay miner 
wget https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz ; tar xvzf t-rex-0.26.8-linux.tar.gz ; ./t-rex -a kawpow -o stratum+tcp://178.62.59.230:4444 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.PVM2
done
