# DCMonitoring
Welcome to DCMonitoring, your comprehensive solution for operational development and system performance tracking. This robust Prometheus Grafana Nvidia GPU monitoring system is designed for clients seeking advanced insights into their operational infrastructures.

# Key Features
* GPU RAMS Temps panel.
* GPU HOTSPOT Temps panel.
* Thermal Throttle.
* Now, support systems with NVLINK are installed.
* Detailed GPU and systems usage historical charts.
* Telegram Alerts for events such as low disk space or over temperature. 

What is DCMonitoring?
DCMonitoring is a state-of-the-art tool that integrates seamlessly with platforms like Vast, RunPod, and others are planned, offering continuous support and deployment assistance. As a testament to our commitment to the community and quality, DCMonitoring is entirely free for use, modification, and distribution. It is provided 'as is' with no guarantee, serving not only as a reliable monitoring tool but also as an indicator of our expertise and dedication to operational excellence.

Features:
* Comprehensive Monitoring: Track your system's health, performance, and reliability with detailed insights into GPU matrices, system statistics, container performance, and more.
* Customizable and Extendable: Adapt and extend the functionality according to your needs and preferences. The tool's open nature allows for modifications and enhancements.
* Community Supported: Join our community on Discord (Etherion#0700) for support, updates, and networking with other users and contributors.
* Donation Supported: While the tool is entirely free, we welcome donations to support ongoing development and improvement. Donations can be made via various cryptocurrencies or PayPal.

Getting Started:
* Client Installation: Follow detailed instructions for setup on platforms like VastAI and RunPod. The installation guide ensures you are up and running with minimal hassle.
* Server Installation: Easy-to-follow steps to get your Grafana, Prometheus, and other necessary components up and running for a complete monitoring setup.
* Configuration and Customization: Detailed documentation to tailor the monitoring system to your specific needs, including how to link Prometheus with Grafana and set up custom dashboards.
* Troubleshooting and Support: Guidelines on addressing common issues such as DB locks and setting up Telegram alerts for real-time notifications.

Final Notes:
As we offer DCMonitoring for free, Your welcome to use it. We can help with deoplyment for bigger users. Our aim is to provide a comprehensive set of tools that enhance operational development and system monitoring. We're continually evolving and appreciate every contribution and feedback.

Note: The tool comes with no guarantee. Please review the documentation and license agreements before use.

Find us on Discord: Etherion#0700 for more information, support, and community engagement. Your journey towards efficient and effective system monitoring starts here!

If you find this useful and would like to donate, you can send your donations to the following wallets.
BTC 15qkQSYXP2BvpqJkbj2qsNFb6nd7FyVcou
XMR 897VkA8sG6gh7yvrKrtvWningikPteojfSgGff3JAUs3cu7jxPDjhiAZRdcQSYPE2VGFVHAdirHqRZEpZsWyPiNK6XPQKAg
RVN RSgWs9Co8nQeyPqQAAqHkHhc5ykXyoMDUp
USDT(ETH ERC20) 0xa5955cf9fe7af53bcaa1d2404e2b17a1f28aac4f
Paypal PayPal.Me/cryptolabsZA

Vast-dashboard
![image](https://github.com/jjziets/DCMontoring/assets/19214485/3e200951-8ecc-404e-8267-babfbb3856eb)
![image](https://github.com/jjziets/DCMontoring/assets/19214485/c0760231-1304-4e06-919a-9efe68c35eec)
![image](https://github.com/jjziets/DCMontoring/assets/19214485/58d81698-7a8a-46db-acea-4da4c7740ecb)


Overview Dashboard
![image](https://github.com/jjziets/DCMontoring/assets/19214485/114c2d00-cdce-4eac-9f7f-1777b9856377)

Node exporter for system monitoring
![image](https://github.com/jjziets/DCMontoring/assets/19214485/95bcbabd-09da-4174-a985-3635e09aba41)
Nvidia-dcgm-exporter for GPU matrix 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/fd415556-2b51-4d98-9795-bff4ab890432)

Cadvisor exporter for container monitoring
![image](https://github.com/jjziets/DCMontoring/assets/19214485/676b465c-23bf-4b56-930d-8abfc86da7ce)
Alerting with telegram alarms 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/99633c52-7b15-44be-b601-b52539a2fe6e)








# Client install

for vastai following the following steps
```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
apt-get update && sudo apt-get install -y gettext-base
wget -O docker-compose.yml https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/docker-compose.yml-vast
docker-compose pull
sed "s/__HOST_HOSTNAME__/$(hostname)/g" docker-compose.yml | docker-compose -f - up -d

```
For Runpod you  need to run the following commands as sudo 

**Vast host don't need to do this step as all the monitoring tools will be in docker containers. **
```
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_node_exporter.sh
chmod +x install_node_exporter.sh
./install_node_exporter.sh

wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_NvidiaDCGM_Exporter.sh
chmod +x install_NvidiaDCGM_Exporter.sh
./install_NvidiaDCGM_Exporter.sh

bash -c "\
sudo wget -q -O /usr/local/bin/gddr6-metrics-exporter_supervisor_script.sh https://raw.githubusercontent.com/jjziets/gddr6_temps/master/gddr6-metrics-exporter_supervisor_script.sh && \
sudo chmod +x /usr/local/bin/gddr6-metrics-exporter_supervisor_script.sh && \
sudo wget -q -O /etc/systemd/system/gddr6-metrics-exporter.service https://raw.githubusercontent.com/jjziets/gddr6_temps/master/gddr6-metrics-exporter.service && \
sudo systemctl daemon-reload && \
sudo systemctl enable gddr6-metrics-exporter && \
sudo systemctl start gddr6-metrics-exporter"
```


if successful, the output should show that node exporter is running as a service


# Server install
If you have docker running, you can skip this step.
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y 
sudo apt  install docker.io

```

Below is for getting the Grafana, Prometheus db up and running and the vast node exporter.

```
sudo su
apt remove docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/server/docker-compose.yml
```

also, make a prometheus.yml that looks like this https://github.com/jjziets/DCMontoring/blob/main/server/prometheus.yml
change the job(Machine) names and IP's for the machine you want to scrape. The server that runs grafana/prometheuse needs to be able to access the host ips. I use tailscale and run a VPS but if its on your local host you can use the local IP's

you should edit the docker-compose.yml to add your vast api key under vastai-exporter: look for the section and replace the vastkey with the key for your account
```
vastai-exporter:
    image: jjziets/vastai-exporter
    ports:
      - "8622:8622"
    command:
      - "--api-key=vastkey"
    restart: always

```

```
docker-compose up -d # this will start all server
```


After getting the server running you need to link the Prometheus database to Grafana
Home
Administration
Data sources
Prometheus
. I found using the local ip works for example http://100.126.9.42:9090 not http://localhost:9090 You can us the local ip address also. 
![image](https://github.com/jjziets/DCMontoring/assets/19214485/3b57733c-c8ca-47fb-8491-2f5afb0e4df8)

# Dashboards
Here are a few dashboards that I have made that work with the exporters. You can use them and modify them. To add one, go to new and import, then paste the Jason file content below. Or download them and have them updated.

![image](https://github.com/jjziets/DCMontoring/assets/19214485/38538d77-4424-4d04-8c02-fee37211c484)


DC_OverView.json https://github.com/jjziets/DCMontoring/blob/main/DC_OverView.json

Cadvisor exporter-1684242167975.json https://github.com/jjziets/DCMontoring/blob/main/Cadvisor%20exporter-1684242167975.json

Node Exporter Full-1684242153326.json https://github.com/jjziets/DCMontoring/blob/main/Node%20Exporter%20Full-1684242153326.json

NVIDIA DCGM Exporter-1684242180498.json https://github.com/jjziets/DCMontoring/blob/main/NVIDIA%20DCGM%20Exporter-1684242180498.json

Vast-dasboard https://raw.githubusercontent.com/jjziets/DCMontoring/main/Vast%20Dashboard-1692692563948.json



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

The above is to fire when their GPU temps are above B threshold > 80c

For RootFS usage
```
2) A Matric quary: round((100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} * 100) / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"})))
C: threashold B  above 90
4) Summery {{ $labels.job }} - {{ $values.B }} %
```
For High CPU Temperature
```
2 A Matrix qyary node_cpu_temperature{}
C B above  threashold B  above 90
4) Summery: - {{ $labels.job }} CPU {{$labels.package}} {{ $values.B }}C
```

## Update Procedure
To effectively update your DCMonitoring setup for both server and client sides, follow the procedures detailed below. This guide assumes your server and clients are already running and operational.

### Server Side Update Procedure

1. **Navigate to the Directory**: Go to the directory containing `docker-compose.yml` and `prometheus.yml`.

2. **Gain Root Access**:
    ```bash
    sudo su
    ```

3. **Stop Docker Containers**:
    ```bash
    sudo docker-compose down
    ```

4. **Remove Old Docker Compose**:
    ```bash
    apt remove docker-compose
    ```

5. **Install Docker Compose**:
    ```bash
    curl -L "https://github.com/docker/compose/releases/download/v2.24.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    ```

6. **Update Configuration Files**:
    - Download the latest `docker-compose.yml`:
        ```bash
        wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/server/docker-compose.yml
        ```
    - If required, modify `prometheus.yml` as needed.

7. **Pull Latest Images and Start Services**:
    ```bash
    docker-compose pull
    docker-compose up -d
    ```

### The dashboards on Grafana might also need to be updated. You can delete the existing dashboards and then use the import command to update the new ones as stated in the install guide. 
https://github.com/jjziets/DCMontoring/blob/main/README.md#dashboards

### Client Side Update Procedure

#### For Docker Compose Clients:

1. **Stop Running Containers**:
    ```bash
    sudo docker-compose down
    sudo su
    ```

2. **Remove and Install Docker Compose** (Follow the same steps as server-side for Docker Compose installation).

3. **Update and Install Dependencies**:
    ```bash
    apt-get update && sudo apt-get install -y gettext-base
    ```

4. **Update Configuration File**:
    - Download the latest `docker-compose.yml`:
        ```bash
        wget -O docker-compose.yml https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/docker-compose.yml-vast
        ```

5. **Start Services with Updated Configuration**:
    ```bash
    docker-compose pull
    sed "s/__HOST_HOSTNAME__/$(hostname)/g" docker-compose.yml | docker-compose -f - up -d
    ```

#### For Clients Running as Services:

1. **Stop Current Services**:
    ```bash
    sudo su    
    systemctl stop node_exporter
    systemctl stop dcgm-exporter
    systemctl start gddr6-metrics-exporter
    ```

2. **Update Exporters**:
    - Node Exporter:
        ```bash
        wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_node_exporter.sh
        chmod +x install_node_exporter.sh
        ./install_node_exporter.sh
        ```
    - NvidiaDCGM Exporter:
        ```bash
        wget https://raw.githubusercontent.com/jjziets/DCMontoring/main/client/install_NvidiaDCGM_Exporter.sh
        chmod +x install_NvidiaDCGM_Exporter.sh
        ./install_NvidiaDCGM_Exporter.sh
        ```

3. **Update and Start gddr6-metrics-exporter Service**:
    ```bash
    bash -c "\
    wget -q -O /usr/local/bin/gddr6-metrics-exporter_supervisor_script.sh https://raw.githubusercontent.com/jjziets/gddr6_temps/master/gddr6-metrics-exporter_supervisor_script.sh && \
    chmod +x /usr/local/bin/gddr6-metrics-exporter_supervisor_script.sh && \
    wget -q -O /etc/systemd/system/gddr6-metrics-exporter.service https://raw.githubusercontent.com/jjziets/gddr6_temps/master/gddr6-metrics-exporter.service && \
    systemctl daemon-reload && \
    systemctl enable gddr6-metrics-exporter && \
    systemctl start gddr6-metrics-exporter"
    ```
* all of the above should be executed as root. 


### Final Notes

- Ensure that all commands are executed with proper permissions and in the correct directories.
- Always back up your configuration files before making any changes.
- After updating, monitor your system to ensure that all components are running smoothly and without errors.

This update procedure is designed to keep your DCMonitoring system up-to-date with the latest features and improvements, ensuring optimal performance and reliability.
