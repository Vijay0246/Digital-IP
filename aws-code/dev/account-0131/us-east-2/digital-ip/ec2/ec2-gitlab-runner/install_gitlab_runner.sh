#! /bin/bash
    SONAR_PATH="http://3.139.78.108:9000"
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
    sudo systemctl start docker 
    sudo yum install git -y
    sudo yum remove python3-pip -y
    sudo yum install python3-pip -y
    sudo yum install python3-setuptools -y
    sudo yum install gcc -y
    export PATH=$PATH:/usr/bin
    sudo pip3 install -U pip
    pip3 install wheel
    pip3 install twine
    sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
    sudo yum install aspnetcore-runtime-5.0 -y
    sudo yum install aspnetcore-runtime-3.1 -y
    sudo yum install dotnet-sdk-5.0 -y
    sudo yum install dotnet-sdk-3.1* -y
    sudo amazon-linux-extras install mono -i -y
    sudo wget https://pkgs.dyn.su/el8/base/x86_64/nuget-5.5.0-6382.1.el8.x86_64.rpm
    sudo yum install nuget-5.5.0-6382.1.el8.x86_64.rpm -y 
    sudo dotnet tool install --global dotnet-sonarscanner
    sudo mv /root/.dotnet /opt
    sudo chmod -R 755 /opt/.dotnet
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
    export GITLAB_RUNNER_DISABLE_SKEL=true
    sudo -E yum install gitlab-runner -y
    sudo dotnet nuget add source "https://gitlab.mouritech.com/api/v4/groups/300/-/packages/nuget/index.json" --name gitlab --username ajaya --password dk4HsAzWNHbxv2ycxNs9 --store-password-in-clear-text
    sudo chmod -R 777 /root/.nuget
    sudo chown -R gitlab-runner:gitlab-runner /root/.nuget
    sudo cp -r /root/.nuget /home/gitlab-runner/
    sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.nuget
    sudo usermod -a -G docker gitlab-runner
    gitlab-runner register --url https://gitlab.mouritech.com/ --registration-token UaxxWZT3MmQtjG8JHwVq  --executor shell -n --leave-runner
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
    cd /home/gitlab-runner
    sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    sudo mkdir -p /home/gitlab-runner/bin && cp ./kubectl /home/gitlab-runner/bin/kubectl && export PATH=$PATH:/home/gitlab-runner/bin
    sudo echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
    # kubectl version --short --client
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install
    cd /opt/
    sudo curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
    sudo unzip sonar-scanner-cli-4.2.0.1873-linux.zip
    sudo echo "sonar.host.url=$SONAR_PATH" | sudo tee -a /opt/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties
    sudo echo "sonar.sourceEncoding=UTF-8" | sudo tee -a /opt/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties
    export PATH="$PATH:/opt/sonar-scanner-4.2.0.1873-linux/bin"
    sudo chown gitlab-runner:gitlab-runner /opt/sonar-scanner-4.2.0.1873-linux
    sudo chmod 777 /opt/sonar-scanner-4.2.0.1873-linux
    cd /usr/local/bin
    sudo bash -c 'curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash'
