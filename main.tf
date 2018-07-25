#
# EC2 Instances
#

resource "aws_instance" "JUMP" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.sg_JUMP.id}"]
    subnet_id = "${aws_subnet.subnet-pub-2.id}"
    tags {
        Name = "${var.sys}-${var.env}-JUMP"
    }
}

resource "aws_instance" "backend" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.sg_backend.id}"]
    subnet_id = "${aws_subnet.subnet-pri-2.id}"
    tags {
        Name = "${var.sys}-${var.env}-backend"
    }
    connection {
        type        = "${var.chef_connection.["type"]}"
        agent       = "${var.chef_connection.["agent"]}"
        private_key = "${file("${var.chef_connection.["private_key"]}")}"
        user        = "${var.chef_connection.["user"]}"    

        bastion_host        = "${aws_instance.JUMP.public_ip}"
        bastion_port        = 22
        bastion_user        = "${var.chef_connection.["user"]}"
        bastion_private_key = "${file("${var.chef_connection.["private_key"]}")}"
    }
    provisioner "file" {
        source      = "chef-scripts/chef-Webserver.sh"
        destination = "/tmp/chef-Webserver.sh"
    }
    provisioner "file" {
        source      = "nginx/backend"
        destination = "/tmp"
    }
    provisioner "remote-exec" {
        inline = [
          "sudo apt update",  
          "sudo chmod +x /tmp/chef-Webserver.sh",
          "sudo /tmp/chef-Webserver.sh", 
        ]
    }  
}

resource "aws_instance" "load_balancer" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.sg_load-balancer.id}"]
    subnet_id = "${aws_subnet.subnet-pub-1.id}"
    tags {
        Name = "${var.sys}-${var.env}-load-balancer"
    }
    connection {
        type        = "${var.chef_connection.["type"]}"
        agent       = "${var.chef_connection.["agent"]}"
        private_key = "${file("${var.chef_connection.["private_key"]}")}"
        user        = "${var.chef_connection.["user"]}"
    }
    provisioner "file" {
        source      = "chef-scripts/chef-Balancerserver.sh"
        destination = "/tmp/chef-Balancerserver.sh"  
    }
    provisioner "local-exec" {
        command = "cp nginx/loadbalancer/default.conf.orig nginx/loadbalancer/default.conf && sed -i '' 's/backend/${aws_instance.backend.private_ip}/' nginx/loadbalancer/default.conf"
    }
    provisioner "file" {
        source      = "nginx/loadbalancer"
        destination = "/tmp"
    }
    provisioner "remote-exec" {
        inline = [
          "sudo apt update",  
          "sudo chmod +x /tmp/chef-Balancerserver.sh",
          "sudo /tmp/chef-Balancerserver.sh", 
        ]
    }
}

output " Please use the load_balancer_ip to access the service" {
  value = ["${aws_instance.load_balancer.public_ip}"]
}

