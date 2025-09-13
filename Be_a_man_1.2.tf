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
user_data = base64encode(<<EOF
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)

echo "
<!doctype html>
<html lang=\"en\" class=\"h-100\">
<head>
<title>Details for EC2 instance</title>
</head>
<body>
<div>
<h1>AWS Instance Details</h1>
<h1>Samurai Katana</h1>

<p> “I, Davey Wheeling Jr, thank Theo and *insert group leader name here*, for teaching me about EC2s in AWS. One step closer to escaping Keisha!" "With this class, I will net 170K per year. 
"I found my wife on a party yacht on Jeju Island. Her name is Jia Han!" </p> 

<br>
# insert an image or GIF
<img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="W3Schools.com">
<img src="https://i.pinimg.com/originals/4c/a6/08/4ca60801263a3bc88dbae1186d31fae2.gif">
<br>


<p><b>Instance Name:</b> $(hostname -f) </p>
<p><b>Instance Private Ip Address: </b> ${local_ipv4}</p>
<p><b>Availability Zone: </b> ${az}</p>
<p><b>Virtual Private Cloud (VPC):</b> ${vpc}</p>
</div>
</body>
</html>
" > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
 EOF
  )


}

output "instance_public_dns" {
  value       = aws_instance.be_a_man_2.public_dns
  description = "The public DNS name of the EC2 instance."
}
