variable "public_key_path" {
  description = "Public key path:"
  default     = "PATH TO PUBLIC KEY OF USER THAT IS USED TO CONNECT TO NEW VM"
}

variable "private_key_path" {
  description = "Private key path:"
  default     = "PATH TO PRIVATE KEY OF USER THAT IS USED TO CONNECT TO NEW VM"
}

variable "key_name" {
  description = "Name of key to use:"
  default     = "NAME OF KEY THAT YOU WANT TO USE TO CONNECT TO THE VM"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

# Amazon Linux AMI 2016.09.1 (HVM), SSD Volume Type
# Only us-west-2 has the right AMI, update for other regions if you need to.
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-b1cf19c6"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-f173cc91"
  }
}
