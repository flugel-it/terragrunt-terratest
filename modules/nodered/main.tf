provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "nodered_instance" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  associate_public_ip_address = true
  key_name = "${var.key_name}"
  tags {
    Name = "${var.instance_name}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh_key_private)}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip}', --private-key ${var.ssh_key_private} -e '${var.python_interpreter}' main.yml" 
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
  azs             = "${var.azs}"
  public_subnets  = "${var.public_subnets}"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  name = "${var.sg_name}"
  vpc_id = "${module.vpc.vpc_id}"
  ingress_cidr_blocks  = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["http-80-tcp"]
  egress_rules = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 1880
      to_port     = 1880
      protocol    = "tcp"
      description = "nodered-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 1880
      to_port     = 1880
      protocol    = "tcp"
      description = "nodered-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}