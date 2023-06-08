#/bin/bash
apt update
apt remove golang
apt install git
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
apt-get install -y datacenter-gpu-manager
git clone https://github.com/NVIDIA/dcgm-exporter.git
cd dcgm-exporter
make binary
make install

echo '[Unit]
Description=DCGM Exporter
After=network.target

[Service]
User=root
ExecStart=/usr/bin/dcgm-exporter
Restart=always

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/dcgm-exporter.service
systemctl daemon-reload
systemctl start dcgm-exporter
systemctl enable dcgm-exporter
#systemctl status dcgm-exporter
