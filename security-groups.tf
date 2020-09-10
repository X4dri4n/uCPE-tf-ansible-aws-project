#Create SG for client VM
resource "aws_security_group" "sc-sg" {
  provider    = aws.ucpe
  name        = "sc-sg"
  description = "Allow TCP from outside"
  vpc_id      = aws_vpc.vpc_ucpe.id
  ingress {
    description = "Allow TCP from our public IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for LB
resource "aws_security_group" "lb-sg" {
  provider    = aws.ucpe
  name        = "lb-sg"
  description = "Allow traffic to Web servers"
  vpc_id      = aws_vpc.vpc_ucpe.id
  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for WS VMs
resource "aws_security_group" "ws-sg" {
  provider    = aws.ucpe
  name        = "ws-sg"
  description = "Allow TCP from VPC"
  vpc_id      = aws_vpc.vpc_ucpe.id
  ingress {
    description = "Allow 22 from Management IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.mgmt-ip]
  }
  ingress {
    description     = "Allow anyone from lb on dedicated port"
    from_port       = var.ws-port
    to_port         = var.ws-port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "Allow traffic from SQL server"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.4.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for SQL VM
resource "aws_security_group" "sql-sg" {
  provider    = aws.ucpe
  name        = "sql-sg"
  description = "Allow traffic from Web Servers"
  vpc_id      = aws_vpc.vpc_ucpe.id
  ingress {
    description = "Allow 22 from Management IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.mgmt-ip]
  }
  ingress {
    description = "Allow TCP from Web servers"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

