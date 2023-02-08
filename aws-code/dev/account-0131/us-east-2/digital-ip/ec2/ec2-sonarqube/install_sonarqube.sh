#!/bin/bash
#latest version
sudo apt-get update
sudo apt-get install unzip software-properties-common wget default-jdk -y
sudo apt-get install postgresql postgresql-contrib -y
sudo sed -i -e 's/peer/trust/g' /etc/postgresql/12/main/pg_hba.conf
sudo sed -i -e 's/ident/md5/g' /etc/postgresql/12/main/pg_hba.conf
sudo service postgresql restart
psql -U postgres -c "CREATE USER sonarqube WITH PASSWORD 'kamisama123';"
psql -U postgres -c "CREATE DATABASE sonarqube OWNER sonarqube;"
psql -U postgres -c "CREATE SCHEMA IF NOT EXISTS sonarqube;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;"
sudo mkdir /downloads/sonarqube -p
cd /downloads/sonarqube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.1.zip
sudo unzip sonarqube-7.9.1.zip
sudo mv sonarqube-7.9.1 /opt/sonarqube
sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube
sudo sed -i -e 's/#RUN_AS_USER=/RUN_AS_USER="sonarqube"/g' /opt/sonarqube/bin/linux-x86-64/sonar.sh
sudo sed -i -e 's/#sonar.jdbc.username=/sonar.jdbc.username=sonarqube/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.password=/sonar.jdbc.password=kamisama123/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.url=jdbc:postgresql/sonar.jdbc.url=jdbc:postgresql/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/localhost/localhost:5432/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/currentSchema=my_schema/ /g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.web.javaAdditionalOpts=/sonar.web.javaAdditionalOpts=-server/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.web.host=0.0.0.0/sonar.web.host=0.0.0.0/g' /opt/sonarqube/conf/sonar.properties
sudo sysctl vm.max_map_count=262144
sudo sysctl fs.file-max 
sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh start
