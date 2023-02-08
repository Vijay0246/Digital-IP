sudo apt-get update -y
sudo apt install openjdk-11-jre-headless -y
export JAVA_HOME=$(find /usr/lib/jvm/openjdk-11* | sed -n '3p')
export PATH=$PATH:$JAVA_HOME/bin
source ~/.bashrc
sudo apt-get install wget -y
sudo apt-get install maven -y
sudo apt-get install docker -y
sudo apt-get install docker.io -y
sudo usermod -a -G docker linuxadmin
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get install git -y
sudo apt install cifs-utils -y
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins


sudo apt-get update -y
sudo git clone https://dandappas:pWFwhgPdvs-A3NkEb-Hn@gitlab.mouritech.com/mt-digital-core-platform/devops_core/jcasc.git
cd /home/linuxadmin/jcasc/jcasc-docker-code/
docker build -t jenkins:jcasc .
sudo docker build -t jenkins:jcasc .
sudo docker run --name jenkins -d --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc
sudo systemctl restart jenkins

cd /opt
sudo apt-get update -y
sudo wget -qO - https://api.bintray.com/orgs/jfrog/keys/gpg/public.key | sudo apt-key add -
sudo echo "deb https://jfrog.bintray.com/artifactory-debs bionic main" | sudo tee /etc/apt/sources.list.d/jfrog.list
sudo apt update -y
sudo apt install jfrog-artifactory-oss -y
sudo systemctl start artifactory.service
sudo systemctl enable artifactory.service
cd ~


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
cd ~

sudo apt-get update -y
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

SONAR_PATH="http://localhost:9000"
export JAVA_HOME=$(find /usr/lib/jvm/openjdk-11* | sed -n '3p')
export PATH=$PATH:$JAVA_HOME/bin
source ~/.bashrc
sudo apt remove python3-pip -y
sudo apt-get install python3-pip -y
sudo apt install python3-setuptools -y
sudo apt-get install gcc -y
export PATH=$PATH:/usr/bin
sudo pip3 install -U pip
pip3 install wheel
pip3 install twine
sudo wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install apt-transport-https-y
sudo apt-get update
sudo apt-get install aspnetcore-runtime-3.1 -y
sudo apt-get install aspnetcore-runtime-5.0 -y
sudo apt-get install dotnet-sdk-3.1* -y
sudo apt-get install -y dotnet-sdk-5.0 -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt install mono-devel -y
sudo wget http://archive.ubuntu.com/ubuntu/pool/universe/n/nuget/nuget_2.8.7+md510+dhx1-1_all.deb
sudo apt-get install nuget -y
sudo dotnet tool install --global dotnet-sonarscanner
sudo mv /root/.dotnet /opt
sudo chmod -R 755 /opt/.dotnet
sudo curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
export GITLAB_RUNNER_DISABLE_SKEL=true
sudo -E apt-get install gitlab-runner -y
sudo dotnet nuget add source "https://gitlab.mouritech.com/api/v4/groups/300/-/packages/nuget/index.json" --name gitlab --username ajaya --password dk4HsAzWNHbxv2ycxNs9 --store-password-in-clear-text
sudo chmod -R 777 /root/.nuget
sudo chown -R gitlab-runner:gitlab-runner /root/.nuget
sudo cp -r /root/.nuget /home/gitlab-runner/
sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.nuget
sudo usermod -a -G docker gitlab-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token UaxxWZT3MmQtjG8JHwVq --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token DJ_83xFAqgjxx5yjc1ys --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token wRvG4yxbt58syzvFBYtE --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token S2snzdEV4sxFitTT5RUx --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token 19kFSyWRRYgKJXJvYCWE --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token bxNByLW7RYy1fJyzoXxj --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token m6M9SbWy-yY3ZwStbsvs --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token ss4WyLQnARcYQU-3za48 --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token th2i-pxx1KNudJAj7j7d --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token SmSx_ht9PSGVi2YZxFs6 --executor shell -n --leave-runner
gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token Q8GTySUNu3oXz-xuPU2w --executor shell -n --leave-runner
sudo chmod -R 777 /home/gitlab-runner/
cd /home/gitlab-runner
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mkdir -p /home/gitlab-runner/bin && cp ./kubectl /home/gitlab-runner/bin/kubectl && export PATH=$PATH:/home/gitlab-runner/bin
sudo chmod +x ./kubectl
sudo cp ./kubectl /home/gitlab-runner/bin/kubectl && export PATH=$PATH:/home/gitlab-runner/bin
sudo echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
cd /opt/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
sudo apt-get install unzip -y
sudo unzip sonar-scanner-cli-4.2.0.1873-linux.zip
sudo echo "sonar.host.url=$SONAR_PATH" | sudo tee -a /opt/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties
sudo echo "sonar.sourceEncoding=UTF-8" | sudo tee -a /opt/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties
export PATH="$PATH:/opt/sonar-scanner-4.2.0.1873-linux/bin"
sudo chown gitlab-runner:gitlab-runner /opt/sonar-scanner-4.2.0.1873-linux
sudo chmod 777 /opt/sonar-scanner-4.2.0.1873-linux
sudo chown gitlab-runner:linuxadmin /opt/sonar-scanner-4.2.0.1873-linux
sudo chmod 777 /opt/sonar-scanner-4.2.0.1873-linux

sudo usermod -a -G docker jenkins
sudo chown jenkins:jenkins /opt/sonar-scanner-4.2.0.1873-linux
cd /usr/local/bin
sudo bash -c 'curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash'