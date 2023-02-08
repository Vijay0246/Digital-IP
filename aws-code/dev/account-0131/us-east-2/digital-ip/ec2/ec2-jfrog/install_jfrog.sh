#!/bin/bash
##Change dir to /opt
cd /opt
sudo yum install wget -y
sudo wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
          http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
sudo yum install jdk-8u131-linux-x64.rpm -y
sudo yum install tar wget -y
sudo wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-oss-rpms.repo
sudo mv  bintray-jfrog-artifactory-oss-rpms.repo /etc/yum.repos.d/
sudo yum install jfrog-artifactory-oss -y
sudo systemctl enable artifactory
sudo systemctl start artifactory
sudo systemctl status artifactory