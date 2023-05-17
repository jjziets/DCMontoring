#!/bin/bash
apt update
apt install lm-sensors
mkdir /var/lib/node_exporter/textfile_collector/
cd /usr/local/bin/cpu_temp.sh
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/cpu_temp.sh 
chmod +x cpu_temp.sh

# Variables
url="https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz"
filename=$(basename -- "$url")
dirname="node_exporter-1.5.0.linux-amd64"

# Download the file
curl -LO "$url"

# Extract the file
tar xzvf "$filename"

# Move the binary to /usr/local/bin and ensure it's executable
sudo mv "$dirname/node_exporter" /usr/local/bin/
sudo chmod +x /usr/local/bin/node_exporter

# Remove the leftover directory and the downloaded file
rm -rf "$dirname"
rm -f "$filename"

# Set up Node Exporter as a system service
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory=/var/lib/node_exporter/textfile_collector  "$@"


[Install]
WantedBy=default.target
EOF'

# Reload systemd, enable and start the Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Print the status of Node Exporter
sudo systemctl status node_exporter
