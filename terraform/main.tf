provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

###
### NETWORK MODULE
###
module "network" {
  source = "./modules/network"
  
  aws_vpc      = "${var.aws_vpc}"
  aws_subnet   = "${var.aws_subnet}"
}


###
### SECURITY
###
# Send public key to KMS for connection to EC2 Managers / Workers
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = "${file(var.ssh_public_key)}"
}


###
### SECURITY GROUPS
###
resource "aws_security_group" "allow-swarm" {
  name   = "allow-swarm"
  vpc_id = "${module.network.aws_vpc_id}"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allow_ssh_from}"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_vpc["cidr_block"]}"]
  }
  
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_vpc["cidr_block"]}"]
  }
  
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["${var.aws_vpc["cidr_block"]}"]
  }
  
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_vpc["cidr_block"]}"]
  }
  
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["${var.aws_vpc["cidr_block"]}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow-swarm"
  }
}


###
### EC2 INSTANCES
###
# EC2 Instance for Docker Swarm Cluster - Manager
resource "aws_instance" "swarm-manager" {
  count         = "${var.swarm_managers}"
  
  ami           = "${lookup(var.amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(module.network.aws_subnet_public_ids, count.index)}"
  key_name      = "${aws_key_pair.mykey.key_name}"
  
  vpc_security_group_ids = ["${aws_security_group.allow-swarm.id}"]
  
  tags = {
    Name = "swarm-manager-${count.index}"
  }
}

# EC2 Instance for Docker Swarm Cluster - Workers
resource "aws_instance" "swarm-worker" {
  count         = "${var.swarm_workers}"
  
  ami           = "${lookup(var.amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(module.network.aws_subnet_public_ids, count.index)}"
  key_name      = "${aws_key_pair.mykey.key_name}"
  #associate_public_ip_address = false
  associate_public_ip_address = true
  
  vpc_security_group_ids = ["${aws_security_group.allow-swarm.id}"]
  
  tags = {
    Name = "swarm-worker-${count.index}"
  }
}

data "template_file" "inventory" {
  template = "${file("templates/inventory.tpl")}"
  
  vars = {
    swarm_managers = "${join("\n", formatlist("%s ansible_ssh_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ssh_private_key}", aws_instance.swarm-manager.*.public_ip))}"
    swarm_workers  = "${join("\n", formatlist("%s ansible_ssh_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ssh_private_key}", aws_instance.swarm-worker.*.public_ip))}"
  }
  
  depends_on = [
    "aws_instance.swarm-manager",
    "aws_instance.swarm-worker",
  ]
}

resource "local_file" "inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "../ansible/inventory"
}
