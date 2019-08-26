variable "aws_region" {
  type        = string
  description = "AWS Region the instance is launched in"
  default     = "us-east-1"
}

### NETWORK MODULE
variable "aws_vpc" {
  description = "Configs to setup the new VPC"
  type        = map(string)
  default = {
    cidr_block           = ""
    enable_dns_support   = ""
    enable_dns_hostnames = ""
  }
}

variable "aws_subnet" {
  description = "List of vectors of subnets and Availability Zones"
  type        = map(list(string))
  default = {
    public_subnets = []
    private_subnets = []
    public_availability_zones = []
    private_availability_zones = []
  }
}
### END NETWORK MODULE

variable "instance_type" {
  type        = string
  description = "AWS type of instance"
  default     = "t3.nano"
}

# CoreOS Linux - https://coreos.com/
/*
variable "amis" {
  description = "List of CoreOS Linux images based on regions"
  type = map(string)
  default = {
    ap-northeast-1 = "ami-0e4285d1d637f9621"
    ap-northeast-2 = "ami-0b0b27a09fa29bcc0"
    ap-south-1 = "ami-05533b69d18ef0f2b"
    ap-southeast-1 = "ami-03b2848db9a1e8331"
    ap-southeast-2 = "ami-0f2a464ec2d360ab3"
    ca-central-1 = "ami-0971c6160f743d7a4"
    cn-north-1 = "ami-05e7c07155bf6194c"
    cn-northwest-1 = "ami-0834edd97d31a9b8c"
    eu-central-1 = "ami-034fd8c3f4026eb39"
    eu-north-1 = "ami-0eb52d157df39a702"
    eu-west-1 = "ami-0b4e04c2cc22a915e"
    eu-west-2 = "ami-0ed4f5a960d2d3527"
    eu-west-3 = "ami-0338e402d6f997560"
    sa-east-1 = "ami-017d7523a36c57feb"
    us-east-1 = "ami-04e51eabc8abea762"
    us-east-2 = "ami-00893b3a357694f05"
    us-gov-east-1 = "ami-06cc1e14c395f91e7"
    us-gov-west-1 = "ami-b5286bd4"
    us-west-1 = "ami-00f0659e80ce3eba1"
    us-west-2 = "ami-073f5d166dc37a1bd"
  }
}
*/

variable "amis" {
  description = "List of Amazon Linux OS images based on regions"
  type = map(string)
  default = {
    ap-east-1 = "ami-570c7726"
    ap-northeast-1 = "ami-0c3fd0f5d33134a76"
    ap-northeast-2 = "ami-095ca789e0549777d"
    ap-northeast-3 = "ami-0ee933a7f81beb045"
    ap-south-1 = "ami-0d2692b6acea72ee6"
    ap-southeast-1 = "ami-01f7527546b557442"
    ap-southeast-2 = "ami-0dc96254d5535925f"
    ca-central-1 = "ami-0d4ae09ec9361d8ac"
    cn-north-1 = "ami-08b835182371dee58"
    cn-northwest-1 = "ami-0829e595217a759b9"
    eu-central-1 = "ami-0cc293023f983ed53"
    eu-north-1 = "ami-3f36be41"
    eu-west-1 = "ami-0bbc25e23a7640b9b"
    eu-west-2 = "ami-0d8e27447ec2c8410"
    eu-west-3 = "ami-0adcddd3324248c4c"
    sa-east-1 = "ami-058943e7d9b9cabfb"
    us-east-1 = "ami-0b898040803850657"
    us-east-2 = "ami-0d8f6eb4f641ef691"
    us-gov-west-1 = "ami-e9a9d388"
    us-gov-east-1 = "ami-a2d938d3"
    us-west-1 = "ami-056ee704806822732"
    us-west-2 = "ami-082b5a644766e0e6f"
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to be provisioned into instances"
  default     = "~/.ssh/mykey.pub"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key used to connect into instances"
  default     = "~/.ssh/mykey.pem"
}

variable "allow_ssh_from" {
  type        = string
  description = "Allow connections to SSH service on Bastion Host"
}

variable "swarm_managers" {
  type        = number
  description = "Number of Docker Swarm manager nodes"
  default     = 1
}

variable "swarm_workers" {
  type        = number
  description = "Number of Docker Swarm worker nodes"
  default     = 2
}

variable "ansible_user" {
  type        = string
  description = "Username used by Ansible to run remote configuration"
}
