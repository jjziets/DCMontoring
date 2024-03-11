#!/bin/bash

# Update and install necessary packages
apt update
apt remove -y golang
apt install -y git wget lsb-release software-properties-common

# Install Go
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
rm go1.20.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile

# Determine Ubuntu version
UBUNTU_VERSION=$(lsb_release -sr)
UBUNTU_VERSION=${UBUNTU_VERSION//.}  # Remove dot from version number (e.g., 20.04 -> 2004)

# Download CUDA keyring and add CUDA repository based on Ubuntu version
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION}/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
add-apt-repository -y "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION}/x86_64/ /"

# Install Data Center GPU Manager
apt-get update
apt-get install -y datacenter-gpu-manager

# Clone, build, and install DCGM Exporter
git clone https://github.com/NVIDIA/dcgm-exporter.git
cd dcgm-exporter
make binary
make install

# Configure DCGM Exporter
mkdir -p /etc/dcgm-exporter/
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/dcgm-exporter/custom-collectors.csv -O /etc/dcgm-exporter/default-counters.csv

# Setup DCGM Exporter service
echo '[Unit]
Description=DCGM Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/bin/dcgm-exporter
Restart=always

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/dcgm-exporter.service

# Reload systemd, enable and start DCGM Exporter service
systemctl daemon-reload
systemctl enable dcgm-exporter
systemctl start dcgm-exporter
