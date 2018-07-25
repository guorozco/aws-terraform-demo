#
# AWS keys - Region - PEM File
#


#
# Please add your access_key and secret_key
#

provider "aws" {
    region = "${var.aws_region}"
    access_key = ""
    secret_key = ""
}

#
# Please change the key by the name you assigned on the AWS console
#

variable "aws_key_name" {
    default = "Please_Change_With_Your_Keyname"
}

#
# Please put the .PEM file on your root directory
#

variable "chef_connection" {
    type = "map"
    default = {
        type = "ssh"
        agent = "false"
        private_key = "./Please_Change_With_Your_Keyname.pem"
        user = "ubuntu"
     }
}
