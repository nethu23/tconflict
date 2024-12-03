provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket         = "awsnethu"
    key            = "nethaji.statefile"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
resource "aws_vpc" "vpc-learning" {
  enable_dns_hostnames = "true"
  cidr_block           = var.vpc_cidr_block

  tags = {
    name = var.vpc_tag
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-learning.id

  tags = {
    name = var.igw_tag
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc-learning.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
    name = var.subnet_tag
  }
}

# resource "aws_subnet" "subnet-2" {
#   vpc_id            = aws_vpc.vpc-learning.id
#   cidr_block        = var.public_subnet2_cidr
#   availability_zone = "us-east-1b"

#   tags = {
#     name = var.subnet2_tag
#   }
# }
# resource "aws_subnet" "subnet-3" {
#   vpc_id            = aws_vpc.vpc-learning.id
#   cidr_block        = var.public_subnet3_cidr
#   availability_zone = "us-east-1c"
#   tags = {
#     name = var.subnet3_tag
#   }
# }
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-learning.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    name = var.rt_tag
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc-learning.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "sg"
  }
}


# resource "aws_instance" "web-1" {
#   ami                         = "ami-0866a3c8686eaeeba"
#   availability_zone           = "us-east-1a"
#   instance_type               = "t2.micro"
#   key_name                    = "kube"
#   subnet_id                   = aws_subnet.subnet-1.id
#   vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
#   associate_public_ip_address = true
#   tags = {
#     Name       = "Prod-Server"
#     Env        = "Prod"
#     Owner      = "nethu"
#     CostCenter = "ABCD"
#   }

#   user_data = <<-EOF
#      #!/bin/bash
#      	sudo apt-get update
#      	sudo apt-get install -y nginx
#      	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
#      	sudo systemctl start nginx
#      	sudo systemctl enable nginx
#      EOF

# }
