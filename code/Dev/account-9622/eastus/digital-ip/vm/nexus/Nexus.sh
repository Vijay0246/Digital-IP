sudo apt-get update
sudo apt install openjdk-8-jdk -y
cd /opt
sudo wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.24.0-02-unix.tar.gz
sudo tar -zxvf nexus-3.24.0-02-unix.tar.gz
sudo mv /opt/nexus-3.24.0-02 /opt/nexus
sudo useradd nexus
sudo echo "nexus ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-nexus-for-sudo-password
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work
sudo sed -i '#run_as_user="nexus" run_as_user="nexus"' /opt/nexus/bin/nexus.rc
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
sudo vi /etc/systemd/system/nexus.service
sudo echo "[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target" >> nexus.service
sudo sed -i 's/application-port=8081/application-port=8083/g' /opt/nexus/etc/nexus-default.properties
sudo su nexus
sudo systemctl enable nexus.service
sudo systemctl start nexus.service