#
# Security group public instance
#

resource "aws_security_group" "sg_load-balancer" {
    name = "sg_ec2-load-balancer"
    description = "sg_load-balancer"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc1.id}"
    tags {
        Name = "sg_${var.sys}-${var.env}-load-balancer"
    }
}

resource "aws_security_group" "sg_JUMP" {
    name = "sg_ec2-JUMP"
    description = "sg_JUMP"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.vpc2.id}"
    tags {
        Name = "sg_${var.sys}-${var.env}-JUMP"
    }
}

#
# Security group private instance
#

resource "aws_security_group" "sg_backend" {
    name = "sg_ec2-backend"
    description = "sg_backend"
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = ["${aws_security_group.sg_load-balancer.id}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.sg_JUMP.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.vpc2.id}"
    tags {
        Name = "sg_${var.sys}-${var.env}-backend"
    }
}
