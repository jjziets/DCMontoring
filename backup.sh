#!/bin/bash

# Get hostname and modify it as per rules (lowercase and replace - with _)
folder_name=$(hostname | tr '[:upper:]' '[:lower:]' | tr '-' '_')

#install pv and pixz 
sudo apt-get install pv pixz


# Generate SSH key and copy it to remote server
echo -e "\nGenerating SSH key and copying to server..."
ssh-keygen -f ~/.ssh/id_rsa -q -N "" 
ssh-copy-id root@192.168.47.100

# Stop services
echo -e "\nStopping services..."
systemctl stop docker.socket
systemctl stop docker
systemctl stop runpod
systemctl disable docker.socket
systemctl disable docker
systemctl disable runpod
systemctl mask docker.socket
systemctl mask docker
systemctl mask runpod


# Check and create folder if it does not exist
echo -e "\nEnsuring the backup folder exists on remote server..."
ssh root@192.168.47.100 "mkdir -p /mnt/user/backup/$folder_name"

# Tar the folder /var/lib/docker and send it to the server
echo -e "\nSending the tar file to server..."
tar -c -I 'pixz -k -0' -f - /var/lib/docker | pv | ssh root@192.168.47.100 "cat > /mnt/user/backup/$folder_name/docker.tar.pixz"

echo -e "\nDone!"
