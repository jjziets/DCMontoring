#!/bin/bash

apt-get install pv pixz

# Get hostname and modify it as per rules (lowercase and replace - with _)
folder_name=$(hostname | tr '[:upper:]' '[:lower:]' | tr '-' '_')

systemctl stop docker.socket
systemctl stop docker
systemctl stop runpod


# Changing directory to root
cd /

# Downloading the tar file from the server
echo -e "\nRetrieving the tar file from server..."
ssh root@192.168.47.100 "cat /mnt/user/backup/$folder_name/docker.tar.pixz" | pv | pixz -d | tar x

# Unmask services
echo -e "\nUnmasking services..."
systemctl unmask docker.socket
systemctl unmask docker
systemctl unmask runpod

# Enable services
echo -e "\nEnabling services..."
systemctl enable docker.socket
systemctl enable docker
systemctl enable runpod

# Reboot the system
echo -e "\nRebooting..."
reboot
