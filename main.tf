terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "iamadmin"
}

module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    cidr_private_subnet = var.cidr_private_subnet
    cidr_public_subnet = var.cidr_public_subnet
    availability_zone = var.availability_zone
}

module "security_group" {
  source = "./security-groups"
  ec2-sg-name = "SG for EC2 Jenkins runner - ssh http(s) jenkins port"
  vpc_id = module.networking.main_vpc_id
}

module "jenkins" {
  source = "./jenkins"
  ami_id = var.ec2_ami_id
  instance_type = "t2.medium"
  tag_name = "Ubuntu Linux EC2 - Jenkins"
  subnet_id = tolist(module.networking.public_subnets)[0]
  sg_for_instance = [module.security_group.sg_ec2_ssh_http]
  enable_public_ip_address = true
  userdata_install_Jenkins = templatefile("./jenkins/jenkins_install.sh",{})
}