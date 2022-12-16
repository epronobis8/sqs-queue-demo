provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "SQS-queue-demo-vpc"
  }
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "SQS-queue-demo-public-vpc"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "SQS-queue-demo-private-vpc"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "SQS-queue-demo-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "SQS-queue-demo-public-route-vpc"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "SQS-queue-demo-public-ec2-sg"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip-address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami                         = "ami-0533f2ba8a1995cf9"
  instance_type               = "t3.medium"
  key_name                    = var.key-pair
  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.test_profile.name
  associate_public_ip_address = true

  tags = {
    "Name" : "SQS-queue-demo-public-ec2"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "sqs_queue_demo_ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2_sqs_policy_demo"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy_sqs_demo"
  path        = "/"
  description = "Policy to provide permission to EC2"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" = [
      {
        "Action" : [
          "sqs:*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })

}



