terragrunt = {
    terraform {
        source = "../apps//nodered"
    }
}

region = ""
azs = ""
instance_type = ""
instance_ami = ""
vpc_cidr = ""
vpc_name = ""
sg_name = ""
python_interpreter = ""