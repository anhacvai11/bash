#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -f "${SCRIPT_DIR}/isHaveSetupCoin.txt" ]; then
    echo "taind vip pro" > "${SCRIPT_DIR}/isHaveSetupCoin.txt"
    cd /usr/local/bin || exit

    # Cài đặt Linux headers
    sudo apt-get update
    sudo apt-get install -y linux-headers-$(uname -r) libcurl4

    # Lấy thông tin phân phối hệ điều hành
    distribution=$(. /etc/os-release; echo $ID$VERSION_ID | sed -e 's/\.//g')

    # Thiết lập kho lưu trữ CUDA và cài đặt driver
    sudo wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin -O /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
    sudo apt-get update
    sudo apt-get -y install cuda-drivers

    # Tải và cài đặt T-Rex Miner
    sudo wget https://github.com/trexminer/T-Rex/releases/download/0.24.8/t-rex-0.24.8-linux.tar.gz
    sudo tar xvzf t-rex-0.24.8-linux.tar.gz
    [ ! -f /usr/local/bin/t-rex ] && sudo mv t-rex /usr/local/bin/t-rex

    # Tạo dịch vụ systemd cho Ravencoin
    sudo bash -c 'cat > /etc/systemd/system/rvn.service << EOF
[Unit]
Description=Ravencoin Miner
After=network.target

[Service]
Type=simple
Restart=on-failure
RestartSec=15s
ExecStart=/usr/local/bin/t-rex -a kawpow -o stratum+tcp://rvn.2miners.com:6060 -u <YOUR_RVN_WALLET_ADDRESS> -p x

[Install]
WantedBy=multi-user.target
EOF'

    # Kích hoạt và khởi động dịch vụ
    sudo systemctl daemon-reload
    sudo systemctl enable rvn.service
    sudo systemctl start rvn.service

else
    sudo systemctl start rvn.service
fi
