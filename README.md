# DCMontoring
Prometheus Grafana nvidia gpu monitoring systems 


# Client install

On the machine that you want to monotir run the following commands
```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
apt-get update && sudo apt-get install -y gettext-base
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/docker-compose.yml
sed "s/__HOST_HOSTNAME__/$(hostname)/g" docker-compose.yml | docker-compose -f - up -d
```
