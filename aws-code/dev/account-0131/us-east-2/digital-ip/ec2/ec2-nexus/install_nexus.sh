#!/bin/bash
##Change dir to /opt
cd /opt
sudo yum install wget -y
sudo wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
          http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
sudo yum install jdk-8u131-linux-x64.rpm -y
java -version
sudo yum install tar wget -y
sudo wget http://download.sonatype.com/nexus/3/nexus-3.30.1-01-unix.tar.gz
sudo tar -zxvf nexus-3.30.1-01-unix.tar.gz
sudo mv /opt/nexus-3.30.1-01 /opt/nexus
sudo useradd nexus
sudo echo "nexus ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-nexus-for-sudo-password
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work
sudo sed -i '#run_as_user="nexus" run_as_user="nexus"' /opt/nexus/bin/nexus.rc
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
sudo sed -i '#application-port=8081" application-port=8083"' /opt/nexus/conf/nexus.properties 
sudo su nexus
sudo systemctl enable nexus
sudo /etc/init.d/nexus run
