#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install nvidia-driver-470 -y

# Verify installation
nvidia-smi

