output "aws_vpc_id" { value = "${aws_vpc.main-vpc.id}" }
output "aws_subnet_public_cidr_blocks" { value = "${aws_subnet.subnet-public.*.cidr_block}" }
output "aws_subnet_public_ids" { value = "${aws_subnet.subnet-public.*.id}" }
