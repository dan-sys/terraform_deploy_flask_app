
output "main_vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnets" {
    value = aws_subnet.subnet_public.*.id
}

output "public_subnets_cidr_block" {
    value = aws_subnet.subnet_public.*.cidr_block
}