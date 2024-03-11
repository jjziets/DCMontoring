#!/bin/bash

# Update and install necessary packages
apt update
apt install -y git wget lsb-release software-properties-common

# Determine if Go is installed and at the correct version
GO_VERSION=$(go version 2>/dev/null | grep -oP 'go1\.\d+\.\d+' || echo "")
REQUIRED_GO_VERSION="1.21"

if [[ -z "$GO_VERSION" || "$GO_VERSION" < "$REQUIRED_GO_VERSION" ]]; then
    # Remove any previous Go installation
    rm -rf /usr/local/go

    # Install the required Go version
    wget https://go.dev/dl/go${REQUIRED_GO_VERSION}.linux-amd64.tar.gz
    tar -C /usr/local -xzf go${REQUIRED_GO_VERSION}.linux-amd64.tar.gz
    rm go${REQUIRED_GO_VERSION}.linux-amd64.tar.gz

    # Set Go PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
    export PATH=$PATH:/usr/local/go/bin
fi
# Determine Ubuntu version
UBUNTU_VERSION=$(lsb_release -sr | tr -d '.')
UBUNTU_CODENAME=$(lsb_release -sc)

# Ensure the CUDA keyring and repository are correctly set up
CUDA_KEYRING_PKG="cuda-keyring_1.0-1_all.deb"
CUDA_REPO_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION}/x86_64"

if ! apt-key list | grep -q "CUDA"; then
  wget "$CUDA_REPO_URL/$CUDA_KEYRING_PKG"
  dpkg -i "$CUDA_KEYRING_PKG"
  add-apt-repository -y "deb $CUDA_REPO_URL/ /"
  rm "$CUDA_KEYRING_PKG"
fi

# Install Data Center GPU Manager
apt-get update
apt-get install -y datacenter-gpu-manager

# Clone, build, and install DCGM Exporter
if [ ! -d "dcgm-exporter" ]; then
  git clone https://github.com/NVIDIA/dcgm-exporter.git
fi
cd dcgm-exporter
make binary
make install

# Configure DCGM Exporter
mkdir -p /etc/dcgm-exporter/
wget -O /etc/dcgm-exporter/default-counters.csv https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/dcgm-exporter/custom-collectors.csv

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
