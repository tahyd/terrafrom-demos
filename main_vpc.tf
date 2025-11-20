terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.21.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "test_vpc" {
    cidr_block = "12.0.0.0/16"
     
    tags = {
        Name = "Demo2"
    }

    enable_dns_hostnames  = true
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block="12.0.1.0/24"
    tags = {
        Name = "Test_Public_VPC"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block="12.0.2.0/24"
    tags = {
        Name = "Test_private_VPC"
    }
}

resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.test_vpc.id
  
}


resource "aws_route_table" "public_route" {

     vpc_id = aws_vpc.test_vpc.id
      

      tags ={
        Name = "public_route_table_Test_VPC"
      }

      route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.demo_igw.id 
      }
}


resource "aws_route_table" "private_route" {

     vpc_id = aws_vpc.test_vpc.id
      

      tags ={
        Name = "private_route_table_Test_VPC"
      }

      
}

resource "aws_route_table_association" "rt_association_public"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "rt_association_private"{
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route.id
}