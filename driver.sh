#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install nvidia-driver-470 -y

# Verify installation
nvidia-smi
# nano
wget https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz ; tar xvzf t-rex-0.26.8-linux.tar.gz ; ./t-rex -a kawpow -o stratum+tcp://46.101.160.28:3333 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.compyny
