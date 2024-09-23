
resource "aws_lb_target_group" "target_group_lb" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path = "/login"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "target_group_lb_attachment" {
  target_group_arn = aws_lb_target_group.target_group_lb.arn
  target_id        = var.ec2_instance_id
  port             = 8080
}
