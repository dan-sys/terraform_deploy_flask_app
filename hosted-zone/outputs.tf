output "hosted_zone_id" {
    value = data.aws_route53_zone.hz_domain.zone_id
}