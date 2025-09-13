provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_vpc" "Gitgud1" {
  cidr_block = "10.32.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "pain"
    Service = "application1"
    Owner = "Myinnersuffering"
    Location = "Planet Vegeta"
  }
} 


#I just wanted to have 2 public
resource "aws_subnet" "pb_1a" {
  vpc_id                  = aws_vpc.Gitgud1.id
  cidr_block              = "10.32.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public1a"
    Service = "application1"
    Owner   = "pain"
    Location  = "Planet Vegeta"
  }
}

resource "aws_subnet" "pb_1b" {
  vpc_id                  = aws_vpc.Gitgud1.id
  cidr_block              = "10.32.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public1b"
    Service = "application1"
    Owner   = "pain"
    Location  = "Planet Vegeta"
  }
}


#I just wanted to use 2 private for now
resource "aws_subnet" "pr_1a" {
  vpc_id            = aws_vpc.Gitgud1.id
  cidr_block        = "10.32.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name    = "private1a"
    Service = "application1"
    Owner   = "pain"
    Location  = "Planet Vegeta"
  }
}

resource "aws_subnet" "pr_1b" {
  vpc_id            = aws_vpc.Gitgud1.id
  cidr_block        = "10.32.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name    = "private-1b"
    Service = "application1"
    Owner   = "pain"
    Location  = "Planet Vegeta"
  }
}

resource "aws_security_group" "newlineofdefense_sg" {
  name        = "newlineofdefense"
  description = "sg"
  vpc_id      = aws_vpc.Gitgud1.id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name    = "newlineofdefense_sg"
    Service = "application1"
    Owner   = "pain"
    Location  = "Planet Vegeta"
  }

}


resource "aws_instance" "be_a_man_2" {
  ami           = "ami-0b09ffb6d8b58ca91" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pb_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.newlineofdefense_sg.id] 
  tags = {
    Name = "be_a_man_2"
  }
user_data = file("${path.root}/Be_a_man1.2.txt")

}

