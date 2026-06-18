terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "trend_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "trend-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.trend_vpc.id

  tags = {
    Name = "trend-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.trend_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "trend-public-subnet"
  }
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.trend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "trend-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public_subnet.id

  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "jenkins_sg" {

  name = "trend-jenkins-sg"

  vpc_id = aws_vpc.trend_vpc.id

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 8080

    to_port = 8080

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "trend-sg"

  }

}

resource "aws_iam_role" "ec2_role" {

  name = "trend-ec2-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ec2.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_role_policy_attachment" "eks" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

resource "aws_iam_role_policy_attachment" "ecr" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

}

resource "aws_iam_role_policy_attachment" "eks_service" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

}

resource "aws_iam_instance_profile" "instance_profile" {

  name = "trend-instance-profile"

  role = aws_iam_role.ec2_role.name

}

resource "aws_instance" "jenkins" {

  ami = "ami-0f918f7e67a3323f0"

  instance_type = "t3.small"

  subnet_id = aws_subnet.public_subnet.id

  key_name = "123"

  vpc_security_group_ids = [

    aws_security_group.jenkins_sg.id

  ]

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash

apt update -y

apt install docker.io git unzip curl -y

systemctl enable docker

systemctl start docker

usermod -aG docker ubuntu

apt install openjdk-21-jdk -y

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian binary/ \
> /etc/apt/sources.list.d/jenkins.list

apt update

apt install jenkins -y

systemctl enable jenkins

systemctl start jenkins

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s \
https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

mv kubectl /usr/local/bin/

curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \
| tar xz

mv eksctl /usr/local/bin/

EOF

  tags = {

    Name = "Jenkins-Server"

  }

}
