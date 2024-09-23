variable "lb_name" {}
variable "lb_type" {}
variable "is_external" { default = false }
variable "sg_enable_ssh_https" {}
variable "subnet_ids" {}
variable "tag_name" {}
variable "target_group_lb_arn" {}
variable "ec2_instance_id" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
variable "lb_listener_default_action" {}
variable "lb_https_listener_port" {}
variable "lb_https_listener_protocol" {}
variable "acm_arn" {}
variable "target_group_lb_attachment_port" {}