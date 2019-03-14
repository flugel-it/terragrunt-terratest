variable "key_name" {}

variable "ssh_key_private" {}

variable "region" {
    description = "AWS region."
    default = "us-east-2"
}

variable "azs" {
    description = "Availability zones."
    default = ["us-east-2a"]
}

variable "instance_type" {
    description = "Instance type of EC2"
    default = "t2.micro"
}
variable "instance_ami" {
    description = "AMI of the ec2 instance."
    default = "ami-0f65671a86f061fcd"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC."
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    description = "VPC name."
    default = "nodered-vpc"
}


variable "public_subnets" {
    description = "Public subnet CIDR block."
    default = ["10.0.101.0/24"]
}
variable "instance_name" {
    description = "Name of AWS EC2 instance to be created."
    default = "nodered-host" 
}

variable "sg_name" {
    description = "Name of security group to be created."
    default = "app-service"
  
}

variable "python_interpreter" {
    description = "Python version for Ansible to use."
}

