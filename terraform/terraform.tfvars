aws_region = "us-east-1"
aws_profile = "terraform"
aws_vpc = {
  name                 = "swarm-lab"
  cidr_block           = "10.0.0.0/20"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}
aws_subnet = {
  public_subnets  = [ "10.0.0.0/24",  "10.0.1.0/24",  "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  
  public_availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

allow_ssh_from = "127.0.0.1/32"
swarm_managers = 1
swarm_workers = 2
ansible_user = "ec2-user"
