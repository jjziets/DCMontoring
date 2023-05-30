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

# Server install
```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/server/docker-compose.yml
```

also make a prometheus.yml that looks like this https://github.com/jjziets/DCMontoring/blob/main/server/prometheus.yml

you should edit the docker-compose.yml and have it mount the prometheus.yml


After getting the server running you need to link the Prometheus database to grafan
Home
Administration
Data sources
Prometheus
. I found using the local ip works for example http://192.168.2.16:9090 not http://localhost:9090
![image](https://github.com/jjziets/DCMontoring/assets/19214485/3b57733c-c8ca-47fb-8491-2f5afb0e4df8)

# Dashboards
Cadvisor exporter-1684242167975.json
Node Exporter Full-1684242153326.json
NVIDIA DCGM Exporter-1684242180498.json

# DB Locked issues
if you Prometheuse db gets locked you can try to remover the lock on reboot with this script
https://github.com/jjziets/DCMontoring/blob/main/RemoverPrometheusDBLock.sh

update the crontab to run the script on reboot. change the user 
@reboot /home/user/prometheuse/RemoverPrometheusDBLock.sh 
