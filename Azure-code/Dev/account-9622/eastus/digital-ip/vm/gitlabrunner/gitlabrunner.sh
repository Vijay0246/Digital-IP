SONAR_PATH="http://localhost:9000"
sudo apt-get update -y
sudo apt install openjdk-11-jre-headless -y
export JAVA_HOME=$(find /usr/lib/jvm/openjdk-11* | sed -n '3p')
export PATH=$PATH:$JAVA_HOME/bin
source ~/.bashrc
sudo apt-get install wget -y
sudo apt-get install maven -y

sudo apt-get install docker -y
sudo apt install docker.io -y
sudo usermod -a -G docker linuxadmin
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get install git -y
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
cd /usr/local/bin
sudo bash -c 'curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash'

