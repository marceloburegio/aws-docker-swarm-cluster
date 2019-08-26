resource "aws_vpc" "main-vpc" {
  cidr_block           = "${var.aws_vpc["cidr_block"]}"
  enable_dns_support   = "${var.aws_vpc["enable_dns_support"]}"
  enable_dns_hostnames = "${var.aws_vpc["enable_dns_hostnames"]}"
  
  tags = {
    Name      = "${var.aws_vpc["name"]}-vpc"
    CreatedBy = "terraform"
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = "${aws_vpc.main-vpc.id}"
  
  tags = {
    Name      = "${var.aws_vpc["name"]}-internet-gw"
    CreatedBy = "terraform"
  }
}

###
### PUBLIC NETWORK
###
resource "aws_subnet" "subnet-public" {
  count = "${length(var.aws_subnet["public_subnets"])}"
  
  vpc_id                  = "${aws_vpc.main-vpc.id}"
  cidr_block              = "${element(var.aws_subnet["public_subnets"], count.index)}"
  availability_zone       = "${element(var.aws_subnet["public_availability_zones"], count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name      = "${element(var.aws_subnet["public_availability_zones"], count.index)}-subnet-public"
    CreatedBy = "terraform"
  }
}

resource "aws_route_table" "route-table-internet-gw" {
  vpc_id = "${aws_vpc.main-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gw.id}"
  }
  
  tags = {
    Name      = "${var.aws_vpc["name"]}-route-table-internet-gw"
    CreatedBy = "terraform"
  }
}

resource "aws_route_table_association" "route-table-subnet-public" {
  count          = "${length(var.aws_subnet["public_subnets"])}"
  
  subnet_id      = "${element(aws_subnet.subnet-public.*.id, count.index)}"
  route_table_id = "${aws_route_table.route-table-internet-gw.id}"
}

###
### PRIVATE NETWORK
###

### DISABLED FOR COST SAVING
/*
resource "aws_eip" "nat-eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet-gw"]
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.subnet-public.1.id}"
  
  depends_on    = [
    "aws_internet_gateway.internet-gw",
    "aws_subnet.subnet-public"
  ]
  
  tags = {
    Name      = "${var.aws_vpc["name"]}-nat-gw"
    CreatedBy = "terraform"
  }
}

resource "aws_route_table" "route-table-nat-gw" {
  vpc_id = "${aws_vpc.main-vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags = {
    Name      = "${var.aws_vpc["name"]}-route-table-nat-gw"
    CreatedBy = "terraform"
  }
}

resource "aws_subnet" "subnet-private" {
  count = "${length(var.aws_subnet["private_subnets"])}"
  
  vpc_id            = "${aws_vpc.main-vpc.id}"
  cidr_block        = "${element(var.aws_subnet["private_subnets"], count.index)}"
  availability_zone = "${element(var.aws_subnet["private_availability_zones"], count.index)}"
  
  tags = {
    Name      = "${element(var.aws_subnet["private_availability_zones"], count.index)}-subnet-private"
    CreatedBy = "terraform"
  }
}

resource "aws_route_table_association" "route-table-subnet-private" {
  count          = "${length(var.aws_subnet["private_subnets"])}"
  
  subnet_id      = "${element(aws_subnet.subnet-private.*.id, count.index)}"
  route_table_id = "${aws_route_table.route-table-nat-gw.id}"
}
*/
