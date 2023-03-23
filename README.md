# DCMontoring
Prometheus Grafana nvidia gpu monitoring systems 


# Client install

On the machine that you want to monotir run the following commands
```
sudo apt remove docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/docker-compose.yml
docker-compose up -d
```
