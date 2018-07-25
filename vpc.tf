#
# VPC Creation
#

#
# VPC 1
#
resource "aws_vpc" "vpc1" {
    cidr_block = "${var.vpc1_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "vpc_${var.sys}-${var.env}-01"
    }
}

#
# VPC 2
#

resource "aws_vpc" "vpc2" {
    cidr_block = "${var.vpc2_cidr}"
    enable_dns_hostnames = false
    tags {
        Name = "vpc_${var.sys}-${var.env}-02"
    }
}

#
# Internet Gateway
#
resource "aws_internet_gateway" "igw1" {
    vpc_id = "${aws_vpc.vpc1.id}"
    tags {
        Name = "igw_${var.sys}-${var.env}-1"
    }
}

resource "aws_internet_gateway" "igw2" {
    vpc_id = "${aws_vpc.vpc2.id}"
    tags {
        Name = "igw_${var.sys}-${var.env}-2"
    }
}

#
# Public Subnet
#

resource "aws_subnet" "subnet-pub-1" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "${var.subnet_pub_vpc1}"
    availability_zone = "${var.aws_az_1}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "sn_${var.sys}-${var.env}-pub-1"
    }
}

