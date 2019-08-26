# AWS Docker Swarm cluster
Using Terraform and Ansible for deploy on AWS a Docker Swarm cluster.

# How to use
First, you need to create a new user on AWS IAM enabling the access type to the API via 'programmatic access'. After that, you must setup the AWS CLI using 'aws configure --profile <PROFILE_NAME>' (e.g. aws configure --profile terraform).

Finally, change the terraform/terraform.tfvars to the values that you need, or use the default one. Check this file to see what are configured by default.
