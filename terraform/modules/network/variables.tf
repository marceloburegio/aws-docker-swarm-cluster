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
