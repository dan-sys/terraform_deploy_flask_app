
output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/daniel/.ssh/flask-app-kp ubuntu@", aws_instance.ec2_instance_jenkins.public_ip)
}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance_jenkins.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.ec2_instance_jenkins.public_ip
}