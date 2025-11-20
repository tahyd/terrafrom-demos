terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.21.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }

  }
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

provider "aws" {
  # Configuration options

  region = "us-east-1"
 
}

# ec2 instance 

resource "aws_instance" "example" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
   #key_name = "my-key-pair"
   key_name = aws_key_pair.web_key.id
   vpc_security_group_ids = [aws_security_group.ssh-access.id]

  tags = {
    Name = "Terraform EC2"
  }
}

resource "aws_key_pair" "web_key" {
    key_name = "mykey"
    #public_key = file("C:/Users/HSBC/.ssh/id_ed25519.pub")
    public_key = tls_private_key.mykey.public_key_openssh

}

resource "aws_security_group" "ssh-access" {
    name = "ssh-access"
    description = "allow ssh connection from internet"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

# create key in aws  and used= the key name here

# create ssh kyes in local machine and store the public key in aws using terraform

# use tsl provider to create the keys 