# nodered-ansible
Provisions a node-red instance in an AWS EC2 instance. 


## Using Terraform with AWS as provider.

1. Supply the AWS credentials/config to environment variables.

```bash
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export TF_VAR_key_name="keynametobeused"
$ export TF_VAR_ssh_key_private="locationofprivatekey"
$ export ANSIBLE_HOST_KEY_CHECKING=False
```

2. Add values for variables in the config.tfvars.

```hcl
python_interpreter = ""
```

3. To run, execute the ff:

```bash
$ terraform init 
$ terraform plan
$ terraform apply
```
4. If successful the, output will be ec2 instance' public ip. 
To access the provisioned node-red, use <ec2_public_ip>:1880/

5. To destroy, execute the ff:

```bash
$ terraform destroy
```
