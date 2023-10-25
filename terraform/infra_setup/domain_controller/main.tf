terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    boundary = {
      source = "hashicorp/boundary"
    }
  }
}

resource "aws_instance" "domain_controller" {
  count = var.create_domain_controller == true ? 1 : 0
  associate_public_ip_address = false
  ami = var.aws_ami
  subnet_id = var.domain_controller_subnet_id
  instance_type = var.domain_controller_instance_type
  vpc_security_group_ids = [ var.domain_controller_secgroup_id ]
  key_name = var.domain_controller_ssh_keypair
  user_data_replace_on_change = true
  user_data_base64 = data.cloudinit_config.k8s_cluster.rendered
  tags = {
    Name = "${var.unique_name}-k8s-cluster"
    app = "kubernetes"
    region = "${var.aws_region}"
  }
}