# DCMontoring
Prometheus Grafana nvidia GPU monitoring systems 
Node exporter for system monitoring
![image](https://github.com/jjziets/DCMontoring/assets/19214485/95bcbabd-09da-4174-a985-3635e09aba41)
Nvidia-dcgm-exporter for GPU matrix 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/4a927ca9-9e0b-4037-8538-acafde3dfea3)
Cadvisor exporter for container monitoring
![image](https://github.com/jjziets/DCMontoring/assets/19214485/676b465c-23bf-4b56-930d-8abfc86da7ce)
Alerting with telegram alarms 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/99633c52-7b15-44be-b601-b52539a2fe6e)





# Client install

On the machine that you want to monitor run the following commands
```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
apt-get update && sudo apt-get install -y gettext-base
wget -O docker-compose.yml https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/docker-compose.yml-vast
sed "s/__HOST_HOSTNAME__/$(hostname)/g" docker-compose.yml | docker-compose -f - up -d
```
if you are using this on runpod you should change the wget command to get the runpod docker-compose file
you should also then install node exporter as node exporter can't run in a docker on runpod. you can use https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_node_exporter.sh
Vast host don't need to do this step.
```
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_node_exporter.sh
chmod +x install_node_exporter.sh
./install_node_exporter.sh
```
if successful the output should show that node exporter is running as a service


# Server install
If you have docker running you can skip this step
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update


```

Below is for getting the grafana and prometheus db up and running.

```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/server/docker-compose.yml
```

also, make a prometheus.yml that looks like this https://github.com/jjziets/DCMontoring/blob/main/server/prometheus.yml

you should edit the docker-compose.yml and have it mount the prometheus.yml in other word use nano to edit the path of prometheus.yml

```
docker-compose up -d # this will start all server
```


After getting the server running you need to link the Prometheus database to Grafan
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
if your Prometheuse db gets locked you can try to remove the lock on reboot with this script
https://github.com/jjziets/DCMontoring/blob/main/RemoverPrometheusDBLock.sh

update the crontab to run the script on reboot. change the user 
@reboot /home/user/prometheuse/RemoverPrometheusDBLock.sh 

# Telegram alerts 
you can set alerts for grafana to send to telegram 
first setup a contact point telegram
![image](https://github.com/jjziets/DCMontoring/assets/19214485/1f70ed1e-8e1d-4079-a173-2722e2abff5a)

Contact point 

![image](https://github.com/jjziets/DCMontoring/assets/19214485/2a19f198-f296-4b1d-a4f2-2004c3f793f0)

Here are the steps to create a bot:
Step 1: Creating the Bot
Open the Telegram app, search for @BotFather and start a chat.
Send the command "/newbot".
BotFather will now ask you to choose a name for your bot. The bot name is the name that users will see in chats, notifications, group members lists. It can be anything, and does not have to be unique.
After you've chosen a name, you'll need to choose a username for your bot. This must be unique, and must end in 'bot'. For example, "my_unique_bot".
After successful creation, BotFather will provide you with a token, which is your API key. This token is used to authorize your bot and send requests to the Bot API. Keep this key secret and secure, and never share it publicly.
Step 2: Getting the Chat ID
A chat id in Telegram is a unique identifier for a chat, either a one-on-one chat or a group chat.
You need to start a chat with your bot or add it to a group chat, then you can get the chat id:
Start a chat with your bot or add it to a group. Send a message to the bot in this chat.
Open a web browser and visit the following URL (replace YOUR_BOT_TOKEN with your bot token):

```
https://api.telegram.org/botYOUR_BOT_TOKEN/getUpdates

```
This will return a JSON response containing data about the messages your bot has received. Look for the "chat" object in the response, which has an "id" field. That "id" is the chat id.

The response will look like this (some details are removed for simplicity):
```
{
    "ok": true,
    "result": [
        {
            "update_id": 8393,
            "message": {
                "message_id": 3,
                "from": {
                    "id": 123,
                    "first_name": "YourName",
                },
                "chat": {
                    "id": 123456789, // This is the chat id
                    "first_name": "YourName",
                    "type": "private"
                },
                "date": 1499402829,
                "text": "Your message text"
            }
        }
    ]
}
```
after this set the templet telegram.message using this https://github.com/jjziets/DCMontoring/blob/main/telegram.message

## creating a rule
There are two ways to do this the easy way is to go to the dashboard and panel and set the rule on there
![image](https://github.com/jjziets/DCMontoring/assets/19214485/5303cca4-868e-47ac-8822-4724e1e7bb9e)


or under the alert rule. 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/81f74ca2-ef67-48f5-9deb-0db0c1c6c701)

in bot cases, you will start at the create rule page
![image](https://github.com/jjziets/DCMontoring/assets/19214485/cd4747d7-8cde-4932-9f4e-d015cf0213cf)
![image](https://github.com/jjziets/DCMontoring/assets/19214485/57302e7c-a244-4cbd-8cc2-7f78ba72dfcb)

The above is to fire when there a gpu temps are above B threasold > 80c

For RootFS usage
2) A Matric quary: round((100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} * 100) / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"})))
C: threashold B  above 90
4) Summery {{ $labels.job }} - {{ $values.B }} %

For High CPU Temperature
2 A Matrix qyary node_cpu_temperature{}
C B above  threashold B  above 90
4) Summery: - {{ $labels.job }} CPU {{$labels.package}} {{ $values.B }}C
