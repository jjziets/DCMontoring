#!/bin/bash

# Attempt to update the package lists
if ! sudo apt update; then
  echo "apt update failed, removing conflicting repository files..."

  # Remove the conflicting repository files if apt update fails
  sudo rm -f /etc/apt/sources.list.d/archive_uri-https_developer_download_nvidia_com_compute_cuda_repos_ubuntu2204_x86_64_-jammy.list
  sudo rm -f /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list
else
  echo "apt update succeeded, no need to remove repository files."
fi

set -e

# Update and install necessary packages
echo "Updating package list and installing necessary packages..."
sudo apt update
sudo apt install -y git wget lsb-release software-properties-common snapd
export DEBIAN_FRONTEND=noninteractive

# Install Go using Snap
if ! command -v go &>/dev/null; then
    echo "Installing Go using Snap..."
    sudo snap install go --classic
else
    echo "Go is already installed via Snap."
fi

# Re-export PATH just in case it's needed for immediate use
export PATH=$PATH:/snap/bin

# Determine Ubuntu version
UBUNTU_VERSION=$(lsb_release -sr | tr -d '.')

# Define CUDA keyring package and repository URL
CUDA_KEYRING_PKG="cuda-keyring_1.0-1_all.deb"
CUDA_REPO_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION}/x86_64"

# Function to check if CUDA repo is already added
is_cuda_repo_added() {
    grep -q "^deb .*$CUDA_REPO_URL" /etc/apt/sources.list /etc/apt/sources.list.d/*.list
}

# Remove duplicate CUDA repository configurations
remove_duplicate_cuda_repos() {
    sudo rm -f /etc/apt/sources.list.d/archive_uri-https_developer_download_nvidia_com_compute_cuda_repos_ubuntu2204_x86_64_-jammy.list
    sudo rm -f /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list
}

# Only add CUDA repo if it's not already added
if ! is_cuda_repo_added; then
    echo "Adding CUDA repository..."
    wget "$CUDA_REPO_URL/$CUDA_KEYRING_PKG"
    sudo dpkg -i "$CUDA_KEYRING_PKG"
    sudo add-apt-repository -y "deb $CUDA_REPO_URL/ /"
    rm "$CUDA_KEYRING_PKG"
else
    echo "CUDA repository is already configured."
    remove_duplicate_cuda_repos
fi


# Install Data Center GPU Manager
echo "Updating package list and installing datacenter-gpu-manager..."
sudo apt-get update
sudo apt-get install -y datacenter-gpu-manager

# Remove existing dcgm-exporter directory if it exists
if [ -d "dcgm-exporter" ]; then
    echo "Removing existing dcgm-exporter directory..."
    rm -rf dcgm-exporter
fi

# Clone, build, and install DCGM Exporter
echo "Cloning DCGM Exporter repository..."
git clone https://github.com/NVIDIA/dcgm-exporter.git
cd dcgm-exporter

# Clean Go build cache and temporary files
echo "Cleaning Go build cache and temporary files..."
go clean -cache -modcache -i -r

# Clean previous build artifacts
echo "Cleaning previous build artifacts..."
make clean || true

echo "Building DCGM Exporter..."
make binary VERBOSE=1 | tee /tmp/dcgm_exporter_build.log

if [ $? -ne 0 ]; then
    echo "Failed to build DCGM Exporter. Check /tmp/dcgm_exporter_build.log for details."
    exit 1
fi

echo "Installing DCGM Exporter..."
sudo make install

# Configure DCGM Exporter
echo "Configuring DCGM Exporter..."
sudo mkdir -p /etc/dcgm-exporter/
sudo wget -O /etc/dcgm-exporter/default-counters.csv https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/dcgm-exporter/custom-collectors.csv

# Setup DCGM Exporter service
echo "Setting up DCGM Exporter service..."
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
echo "Starting DCGM Exporter service..."
sudo systemctl daemon-reload
sudo systemctl enable dcgm-exporter
sudo systemctl start dcgm-exporter

echo "Installation completed successfully."
