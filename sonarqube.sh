sudo apt-get update -y
sudo apt-get install openjdk-11-jdk -y
java -version
sudo apt update -y
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt install postgresql postgresql-contrib -y
sudo sed -i -e 's/peer/trust/g' /etc/postgresql/12/main/pg_hba.conf
sudo sed -i -e 's/ident/md5/g' /etc/postgresql/12/main/pg_hba.conf
sudo systemctl enable postgresql.service
sudo systemctl start  postgresql.service
sudo su - postgresql
psql -U postgres -c "CREATE USER sonar WITH PASSWORD 'p@ssw0rd';"
psql -U postgres -c "CREATE DATABASE sonarqube OWNER sonar;"
psql -U postgres -c "CREATE SCHEMA IF NOT EXISTS sonar;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;" && exit
sudo sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo mkdir /sonarqube/
cd /sonarqube/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
sudo apt-get install zip -y
sudo unzip sonarqube-8.3.0.34182.zip -d /opt/
sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R
sudo sed -i -e 's/#sonar.jdbc.username=/sonar.jdbc.username=sonar/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.password=/sonar.jdbc.password=p@ssw0rd/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.jdbc.url=jdbc:postgresql/sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.web.port=9000/sonar.web.port=9000/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.web.javaAdditionalOpts=-server/sonar.web.javaAdditionalOpts=-server/g' /opt/sonarqube/conf/sonar.properties
sudo sed -i -e 's/#sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError/sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError/g' /opt/sonarqube/conf/sonar.properties
sudo echo "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target" >> sonarqube.service
sudo mv sonarqube.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube
sudo systemctl status -l sonarqube