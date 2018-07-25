#
# Route tables file
#

#
# Route Table - Public
#
resource "aws_route_table" "rtb-pub-1" {
    vpc_id = "${aws_vpc.vpc1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw1.id}"
    }
    route {
        cidr_block = "${var.vpc2_cidr}"
        gateway_id = "${aws_vpc_peering_connection.vpc1-vpc2.id}"
    }
    tags {
        Name = "rtb_${var.sys}-${var.env}-pub-1"
    }
}

#
# Route Table Association - Public
#
resource "aws_route_table_association" "pub-1" {
    subnet_id = "${aws_subnet.subnet-pub-1.id}"
    route_table_id = "${aws_route_table.rtb-pub-1.id}"
}

#
# Elastic IP
#
resource "aws_eip" "nat_eip" {
    vpc = true
}

#
# Nat Gateway
#
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.subnet-pub-2.id}"
  depends_on = ["aws_internet_gateway.igw2"]
}

#
# Public Subnets
#
resource "aws_subnet" "subnet-pub-2" {
    vpc_id = "${aws_vpc.vpc2.id}"
    cidr_block = "${var.subnet_pub_vpc2}"
    availability_zone = "${var.aws_az_1}"
    map_public_ip_on_launch = "true"

    tags {
        Name = "sn_${var.sys}-${var.env}-pub-2"
    }
}

#
# Route Table - Public
#
resource "aws_route_table" "rtb-pub-2" {
    vpc_id = "${aws_vpc.vpc2.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw2.id}"
    }
    tags {
        Name = "rtb_${var.sys}-${var.env}-pub-2"
    }
}

#
# Route Table Association - Public
#
resource "aws_route_table_association" "pub-2" {
    subnet_id = "${aws_subnet.subnet-pub-2.id}"
    route_table_id = "${aws_route_table.rtb-pub-2.id}"
}

#
#  Private Subnet
#
resource "aws_subnet" "subnet-pri-2" {
    vpc_id = "${aws_vpc.vpc2.id}"
    cidr_block = "${var.subnet_pri_vpc2}"
    availability_zone = "${var.aws_az_2}"
    tags {
        Name = "sn_${var.sys}-${var.env}-pri-2"
    }
}

#
# Route table private
#
resource "aws_route_table" "rtb-pri" {
    vpc_id = "${aws_vpc.vpc2.id}"
    route {
        cidr_block = "${var.vpc1_cidr}"
        gateway_id = "${aws_vpc_peering_connection.vpc1-vpc2.id}"
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }
    tags {
        Name = "rtb_${var.sys}-${var.env}-pri"
    }
}

#
# Route table association - Private
#
resource "aws_route_table_association" "pri-2" {
    subnet_id = "${aws_subnet.subnet-pri-2.id}"
    route_table_id = "${aws_route_table.rtb-pri.id}"
}

#
# Peering between both VPC
#
resource "aws_vpc_peering_connection" "vpc1-vpc2" {
  peer_vpc_id   = "${aws_vpc.vpc1.id}"
  vpc_id        = "${aws_vpc.vpc2.id}"
  auto_accept   = true

  tags {
    Name = "Peering-${var.sys}-${var.env}"
  }
}
