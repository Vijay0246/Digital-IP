data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "jenkins-sg" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/security-group/sg-jenkins-ec2/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "efs-jenkins" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "mt-tfstate-${var.env_name}-${var.aws_account_short_id}"
    key    = "terraform-code/${var.env_name}/${var.local_dir}/${var.aws_region}/${var.project_name}/efs/efs-jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}

module "ec2" {
  source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/ec2"

  instance_count = 1

  name          = "jenkins-master-for-${var.project_name}-${var.env_name}"
  ami           = var.jenkins_master_ami
  instance_type = var.jenkins_master_instance_type
  key_name   = var.jenkins_master_keypair_name
  subnet_id     = tolist(data.terraform_remote_state.vpc.outputs.private_subnets)[0]
  vpc_security_group_ids      = [data.terraform_remote_state.jenkins-sg.outputs.id]
  associate_public_ip_address = false

 # user_data = "${file("jenkins_setup.sh")}"
  user_data = <<EOF
  #! /bin/bash
    sudo yum update -y
    sudo yum -y install java-1.8*
    export JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | sed -n '3p')
    export PATH=$PATH:$JAVA_HOME/bin
    source ~/.bash_profile
    sudo yum -y install wget
    sudo yum install -y docker
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    sudo yum install git -y
    sudo yum remove python3-pip -y
    sudo yum install python3-pip -y
    sudo yum install python3-setuptools -y
    sudo yum install gcc -y
	sudo pip3 -U pip
    sudo pip3 install wheel
    sudo pip3 install twine
    sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
    sudo yum install aspnetcore-runtime-5.0 -y
    sudo yum install aspnetcore-runtime-3.1 -y
    sudo yum install dotnet-sdk-5.0 -y
    sudo yum install dotnet-sdk-3.1* -y
    sudo amazon-linux-extras install mono -i -y
    sudo wget https://pkgs.dyn.su/el8/base/x86_64/nuget-5.5.0-6382.1.el8.x86_64.rpm
    sudo yum install nuget-5.5.0-6382.1.el8.x86_64.rpm -y
    sudo curl https://packages.microsoft.com/config/rhel/7/prod.repo > ./microsoft-prod.repo
    sudo cp ./microsoft-prod.repo /etc/yum.repos.d/
    sudo wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/n/nuget-2.8.7-3.el7.x86_64.rpm
    sudo yum install nuget-2.8.7-3.el7.x86_64.rpm -y
    sudo dotnet tool install --global dotnet-sonarscanner
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
    sudo export GITLAB_RUNNER_DISABLE_SKEL=true
    sudo -E yum install gitlab-runner -y
    sudo yum install -y amazon-efs-utils
    sudo yum -y install jenkins
    sudo systemctl stop jenkins
    sudo echo ${data.terraform_remote_state.efs-jenkins.outputs.efs_id}.efs.${var.aws_region}.amazonaws.com:/ /var/lib/jenkins efs defaults,_netdev 0 0 >> /etc/fstab
    sudo mount -t efs -o tls ${data.terraform_remote_state.efs-jenkins.outputs.efs_id}:/ /var/lib/jenkins
    sudo chown -R jenkins:jenkins /var/lib/jenkins
    sudo usermod -a -G docker jenkins
    sudo systemctl restart jenkins
EOF

root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 50
    },
  ]

  tags = {
    "env"      = var.env_name
    "project" = var.project_name
    "purpose" = "jenkins"
  }
}
