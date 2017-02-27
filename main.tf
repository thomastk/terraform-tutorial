# Specify the provider as AWS
provider "aws" {
  region = "${var.aws_region}"
}

# Security group to access the instance over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "wp_access"
  description = "SSH and HTTP access to the Wordpress instances"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "wordpress" {
  connection {
    # The default username for our AMI
    user = "ec2-user"
  }

  instance_type = "t2.medium"

  # Lookup the correct AMI based on the region, only updated for us-west-2 
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["wp_access"]

  provisioner "file" {
     source = "provisioners/install-wordpress-amzn-linux.sh"
     destination = "/tmp/install-wordpress-amzn-linux.sh"
     connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file(var.private_key_path)}"
        }
    }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install-wordpress-amzn-linux.sh",
      "sudo /tmp/install-wordpress-amzn-linux.sh",
      "sudo rm /tmp/install-wordpress-amzn-linux.sh"
    ]
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
    }
  }
}
