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

module "target_group_lb" {
  source = "./load-balancer-target-group"
  lb_target_group_name = "jenkins-lb-target-group"
  lb_target_group_port = 8080
  lb_target_group_protocol = "HTTP"
  vpc_id = module.networking.main_vpc_id
  ec2_instance_id = module.jenkins.ec2_instance_id
}

module "application_load_balancer" {
  source = "./load-balancer"
  lb_name = "application-lb"
  is_external = false
  lb_type = "application"
  sg_enable_ssh_https = module.security_group.sg_ec2_ssh_http
  subnet_ids = tolist(module.networking.public_subnets)
  tag_name = "apllication-lb"
  target_group_lb_arn = module.target_group_lb.lb_target_group_arn
  ec2_instance_id = module.jenkins.ec2_instance_id
  lb_listener_port = 80
  lb_listener_default_action = "forward"
  lb_listener_protocol = "HTTP"
  lb_https_listener_port = 443
  lb_https_listener_protocol = "HTTPS"
  acm_arn = module.aws_ceritificate_manager.acm_arn
  target_group_lb_attachment_port = 8080
}

module "hosted_zone" {
  source          = "./hosted-zone"
  domain_name     = "jenkins.adelani.xyz"
  aws_lb_dns_name = module.application_load_balancer.aws_lb_dns_name
  aws_lb_zone_id  = module.application_load_balancer.aws_lb_zone_id
}

module "aws_ceritificate_manager" {
  source         = "./certificate-manager"
  domain_name    = "jenkins.adelani.xyz"
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}