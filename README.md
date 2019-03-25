# Terragrunt and Terratest example

## Overview

This is an example on how to use Terragrunt and Terratest on existing terraform modules. The example includes a terraform module for provisioning a node-red app in EC2.
Both libraries were developed at Gruntwork.

### Pre-requisites
- [terraform][terraform_tool] v0.11.12
- [terragrunt][terragrunt_tool] v0.18.1
- [terratest][terratest_tool]
- ansible 2.7.8
- golang go1.12

2. Supply credentials and config as environment variables
```bash
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export TF_VAR_key_name="keynametobeused"
$ export TF_VAR_ssh_key_private="locationofprivatekey"
$ export ANSIBLE_HOST_KEY_CHECKING=False
```

### Terragrunt

One of the motivation for Terragrunt is to provide a way to keep Terraform code DRY. The idea is to define the infrastructure code once and expose input variables that can be use to define different environments (e.g. prod, qa, stage, dev). Terragrunt also provides the following benefits:

- Keeping CLI flags and Remote state configuration DRY
- Run terraform commands on multiple modules
- Using multiple AWS accounts

In this setup the nodered .tf files along with the ansible script are define under modules and a dev environment is define by a single .tfvars file.

```
└── modules
    ├── nodered
    │   ├── main.tf
    │   ├── main.yml
    │   ├── outputs.tf
    │   ├── variables.tf
    |
└── environments
    ├── dev
    │   ├── nodered
    |   │   ├── terraform.tfvars
```

The dev environment is setup to use the local nodered module with the ff config:

```hcl
terragrunt = {
    terraform {
        source = "../../../modules//nodered"
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
```

A different env can be added by defining a separate .tfvars file (e.g environmnents/qa/nodered/terraform.tfvards).
Instead of using `terraform`, the `terragrunt` commands are use to run the scripts.

```bash
terragrunt get
terragrunt plan
terragrunt apply
terragrunt output
terragrunt destroy
```

See [Terragrunt repo][terragrunt_tool] for more info.

#### Run Terragrunt for a dev deployment of a nodered module.

1. Download terragrunt files [here][terragrunt_tool].

2. To deploy, run the ff terragrunt commands.
```bash
cd environments/dev/nodered
terragrunt get
terragrunt plan
terragrunt apply
```

3. Display output and destroy to clean up the resources that were created.
```bash
terragrunt output
terragrunt destroy
```

### Terratest

Terratest (Go Library) provides a way to write to automated tests for existing infrastrcuture codes.
In this example, a HTTP test is use to check if the node-red application was successfully deployed. Once verified, the resources are destroyed automatically.
See [Terratest repo][terratest_tool] for more info.

```
└── modules
    ├── nodered
    │   ├── main.tf
    │   ├── main.yml
    │   ├── outputs.tf
    │   ├── variables.tf
    |
└── tests
    ├── nodered
    │   ├── nodered_test.go
```

#### Run tests
1. Make sure to have Go installed.

2. Add the Terratest libraries 
```bash
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/http-helper
```

3. Run go test.
```bash
cd tests/nodered
go test -v -run TestHttpNodeRed
```
[terragrunt_tool]:https://github.com/gruntwork-io/terragrunt
[terratest_tool]:https://github.com/gruntwork-io/terratest
[terraform_tool]:https://www.terraform.io/docs/index.html
