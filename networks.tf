#Create VPC in eu-central-1
resource "aws_vpc" "vpc_ucpe" {
  provider             = aws.ucpe
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-ucpe"
  }
}

provider "aws" {
  region = "eu-central-1"
}

#Create private hosted zone
resource "aws_route53_zone" "private" {
  name = "swisscom.com"

  vpc {
    vpc_id = aws_vpc.vpc_ucpe.id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}


#Create IGW in eu-central-1 vpc
resource "aws_internet_gateway" "igw-frank" {
  provider = aws.ucpe
  vpc_id   = aws_vpc.vpc_ucpe.id
}

#Get all available AZ's in VPC for eu-central
data "aws_availability_zones" "azs" {
  provider = aws.ucpe
  state    = "available"
}

#Create subnet for client VM
resource "aws_subnet" "subnet_1" {
  provider          = aws.ucpe
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_ucpe.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet for WebServer1
resource "aws_subnet" "subnet_2" {
  provider          = aws.ucpe
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_ucpe.id
  cidr_block        = "10.0.2.0/24"
}

#Create subnet for WebServer2
resource "aws_subnet" "subnet_3" {
  provider          = aws.ucpe
  availability_zone = element(data.aws_availability_zones.azs.names, 2)
  vpc_id            = aws_vpc.vpc_ucpe.id
  cidr_block        = "10.0.3.0/24"
}

#Create subnet for SQL server
resource "aws_subnet" "subnet_4" {
  provider          = aws.ucpe
  availability_zone = element(data.aws_availability_zones.azs.names, 3)
  vpc_id            = aws_vpc.vpc_ucpe.id
  cidr_block        = "10.0.4.0/24"
}

#Create route table
resource "aws_route_table" "internet_route" {
  provider = aws.ucpe
  vpc_id   = aws_vpc.vpc_ucpe.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-frank.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "ucpe-RT"
  }
}

#Modify default route table of VPC with our own table entries
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.ucpe
  vpc_id         = aws_vpc.vpc_ucpe.id
  route_table_id = aws_route_table.internet_route.id
}

