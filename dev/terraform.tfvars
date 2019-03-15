terragrunt = {
    terraform {
        source = "../apps//nodered"
    }
}

region = "us-east-2"
azs = ["us-east-2a"]
instance_type = "t2.micro"
instance_ami = "ami-0f65671a86f061fcd"
vpc_cidr = "10.0.0.0/16"
vpc_name = "nodered-vpc"
public_subnets = ["10.0.101.0/24"]
instance_name = "nodered-host"
sg_name = "app-service"
python_interpreter = "ansible_python_interpreter=/usr/bin/python3"