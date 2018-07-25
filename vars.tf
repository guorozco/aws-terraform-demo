#
# UBUNTU AMI - Please only change the AMI for another UBUNTU PUBLIC AMI
#

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-43a15f3e"
    }
}

#
# EC2 instance Type
#

variable "aws_instance_type" {
    description = "EC2 instance type"
    default = "t2.micro"
}

#
# Set your enviorment (DEV UAT PROD)
#

variable "env" {
    default = "UAT"
}

#
# Set your company name
#

variable "sys" {
    default = "Fake-Company"
}

#
# AWS Region
#

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

#
# Set VPCs VPC1 and VPC2
#

variable "vpc1_cidr" {
    description = "CIDR for the VPC1"
    default = "172.10.0.0/16"
}

variable "vpc2_cidr" {
    description = "CIDR for the VPC1"
    default = "172.20.0.0/16"
}

variable "subnet_pub_vpc1" {
    description = "CIDR for the Public Subnet on VPC 1"
    default = "172.10.0.0/24"
}

variable "subnet_pub_vpc2" {
    description = "CIDR for the Public Subnet on VPC 2"
    default = "172.20.100.0/24"
}

variable "subnet_pri_vpc2" {
    description = "CIDR for the Private Subnet on VPC 2"
    default = "172.20.0.0/24"
}

variable "aws_az_1" {
    description = "EC2 AZ vor subnet 1"
    default = "us-east-1a"
}

variable "aws_az_2" {
    description = "EC2 AZ vor subnet 2"
    default = "us-east-1b"
}
