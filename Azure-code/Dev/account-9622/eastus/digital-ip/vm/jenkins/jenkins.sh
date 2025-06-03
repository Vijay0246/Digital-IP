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


