#!/bin/bash
apt update
apt install lm-sensors -y 
apt install jq -y
apt install xz-utils -y
mkdir -p /var/lib/node_exporter/textfile_collector
cd /usr/local/bin/
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/run_cpu_temp.sh 
chmod +x run_cpu_temp.sh

ENTRY="@reboot screen -dmS cpu_temp.sh /usr/local/bin/run_cpu_temp.sh"
# Get the current crontab, append your entry to it, and write it back out
(crontab -l; echo "$ENTRY" ) | crontab -
# run the cpu temp updater
screen -dmS cpu_temp.sh /usr/local/bin/run_cpu_temp.sh

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

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory=/var/lib/node_exporter/textfile_collector


[Install]
WantedBy=default.target
EOF'

# Reload systemd, enable and start the Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Print the status of Node Exporter
#sudo systemctl status node_exporter


