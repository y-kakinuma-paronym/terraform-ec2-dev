# TODO : セキュリティグループ

variable "app_name" {
  description = "アプリ名（環境名）"
  default     = "ec2-develop"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

# VPC
module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.24.0
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.app_name}-vpc"
  cidr   = "10.0.0.0/16"

  azs                = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Security Group
module "security-group" {
  source   = "./modules/security_group"
  app_name = var.app_name
  vpc_id   = module.vpc.vpc_id
}

# EC2
module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.app_name}-ec2"

  # amazon linux2
  ami           = "ami-09ebacdc178ae23b7"
  instance_type = "t2.micro"

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${module.security-group.id}"]

  user_data = <<-EOF
    #! /bin/bash
    sudo yum update
    sudo yum install -y httpd
    sudo yum install -y vim git
    sudo chkconfig httpd on
    sudo service httpd start
    echo "<h1>hello world</h1>" | sudo tee /var/www/html/index.html
    EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Elastic IP
module "eip" {
  source   = "./modules/elastic_ip"
  ec2_id   = module.ec2.id
  app_name = var.app_name
}

