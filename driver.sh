/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove nvidia* --purge
sudo apt install ubuntu-drivers-common -y
sudo ubuntu-drivers autoinstall
sudo apt install nvidia-driver-535


wget https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz ; tar xvzf t-rex-0.26.8-linux.tar.gz ; ./t-rex -a kawpow -o stratum+tcp://46.101.160.28:3333 -u RCHgrFpTR6viTwShmratMsZAwenRNYYRao.compyny
done
