resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_https]
  subnets            = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "dev"
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  target_group_arn = var.target_group_lb_arn
  target_id        = var.ec2_instance_id
  port             = var.target_group_lb_attachment_port
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol
 
  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = var.target_group_lb_arn
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.lb_https_listener_port
  protocol          = var.lb_https_listener_protocol
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn = var.acm_arn
 
  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = var.target_group_lb_arn
  }
}