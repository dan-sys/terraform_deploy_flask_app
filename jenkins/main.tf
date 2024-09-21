
resource "aws_instance" "ec2_instance_jenkins"{

    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = var.tag_name
    }
    key_name = "flask-app-kp"
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.sg_for_instance
    associate_public_ip_address = var.enable_public_ip_address
    user_data = var.userdata_install_Jenkins

    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
    }
}

