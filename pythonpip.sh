#!/bin/bash
sudo apt update
sudo apt install python3 python3-pip -y
pip install azure-identity azureml-core
pip install setuptools
pip install --upgrade azure-identity azureml-core
pip install azure-cli
pip install paramiko
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
done
