1.Install packer from below link based on OS
     https://learn.hashicorp.com/tutorials/packer/getting-started-install
2.Clone the repo and go to below directory.
    1. git clone https://gitlab.mouritech.com/mt-digital-core-platform/devops_core/terraform-code.git
    2. cd terraform-code/dev/account-0131/us-east-2/digital-ip/packer
3. Update values.json with aws_access_key and aws_secret_key.
4. Command to create digital-ip-worker-node AMI
     packer build -var-file=values.json digital-ip-worker.json
