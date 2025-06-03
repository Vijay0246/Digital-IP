sudo apt-get update -y
sudo apt install openjdk-11-jre-headless -y
sudo apt-get install git -y
sudo apt-get install docker -y
sudo usermod -a -G docker linuxadmin
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
sudo apt-get install wget -y
sudo git clone https://dandappas:pWFwhgPdvs-A3NkEb-Hn@gitlab.mouritech.com/mt-digital-core-platform/devops_core/jcasc.git
cd /home/linuxadmin/jcasc/jcasc-docker-code/
docker build -t jenkins:jcasc .
sudo docker build -t jenkins:jcasc .
sudo docker run --name jenkins -d --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc