#!/bin/bash
sudo yum install git -y
sudo yum -y install java-1.8*
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo systemctl start docker
sudo yum install wget -y
sudo git clone https://dandappas:pWFwhgPdvs-A3NkEb-Hn@gitlab.mouritech.com/mt-digital-core-platform/devops_core/jcasc.git
cd /jcasc/jcasc-docker-code
docker build -t jenkins:jcasc .
docker run --name jenkins -d --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc
