#!/bin/bash

# Update system packages
sudo apt update -y

# Install necessary packages
sudo apt install -y curl tar

# Get the latest version of Node Exporter
VERSION=$(curl https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Download and extract Node Exporter
curl -LO "https://github.com/prometheus/node_exporter/releases/download/${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz"
tar xvf "node_exporter-${VERSION}.linux-amd64.tar.gz"

# Move the Node Exporter binary to /usr/local/bin
sudo mv "node_exporter-${VERSION}.linux-amd64/node_exporter" /usr/local/bin

# Set up Node Exporter as a system service
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF'

# Reload systemd, enable and start the Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Clean up downloaded files
rm -rf "node_exporter-${VERSION}.linux-amd64"
rm "node_exporter-${VERSION}.linux-amd64.tar.gz"

# Print the status of Node Exporter
sudo systemctl status node_exporter
