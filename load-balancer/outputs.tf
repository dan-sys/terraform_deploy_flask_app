output "aws_lb_dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.load_balancer.zone_id
}