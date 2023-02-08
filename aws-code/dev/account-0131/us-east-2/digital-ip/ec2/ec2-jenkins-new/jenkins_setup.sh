#! /bin/bash
    sudo yum update -y
    sudo yum -y install java-1.8*
    export JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | sed -n '3p')
    export PATH=$PATH:$JAVA_HOME/bin
    source ~/.bash_profile
    sudo yum -y install wget
    sudo yum install maven -y
    sudo yum install -y docker
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    sudo yum install git -y
    sudo yum install -y amazon-efs-utils
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum -y install jenkins
    sudo systemctl stop jenkins
    sudo echo ${data.terraform_remote_state.efs-jenkins.outputs.efs_id}.efs.${var.aws_region}.amazonaws.com:/ /var/lib/jenkins efs defaults,_netdev 0 0 >> /etc/fstab
    sudo mount -t efs -o tls ${data.terraform_remote_state.efs-jenkins.outputs.efs_id}:/ /var/lib/jenkins
    sudo chown -R jenkins:jenkins /var/lib/jenkins
    sudo systemctl restart jenkins
