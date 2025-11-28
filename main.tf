resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "tharun-vpc"
  }
}

resource "aws_subnet" "tharun_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public subnet"
  }
}

resource "aws_subnet" "tharun_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}

 resource"aws_route_table" "tharun_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "tharun_public"
  }
} 

resource "aws_route_table" "tharun_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tharun.id
  }
  tags = {
    Name = "tharun_private"
  }
}
 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.tharun_public.id
  route_table_id = aws_route_table.tharun_public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.tharun_private.id
  route_table_id = aws_route_table.tharun_private.id
}

resource "aws_eip" "tharun" {
  tags = {
    Name = "t-eip"
  }
}

resource "aws_nat_gateway" "tharun" {
  allocation_id = aws_eip.tharun.id
  subnet_id     = aws_subnet.tharun_private.id
  tags = {
    Name = "gw NAT"
  }
}

resource "aws_key_pair" "t_key" {
  key_name   = "tharun-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAADzBwzt7Qyaq2jPfg/HW1lOdnCCHp4jmnICK4EK5FDILrkxrr2gKd/703xs3xqQzFJq0qtIV+PGnosen4MDE7vSlU92NLDGh7UqJkyqZ5c2pgIoH1KSiWBMLkgSZDIup2vmQzXwy9nU8TH5PfN3yCTnwp2FfDD3WfE2N++tW3SoeiFYJ0NsDGMES3SMT4e3dKBfGe6R3eJDqtideSFTil58Q+ijW5UccNpWDRvLU6iVbOPoYwl7jvg+YVRAYasAA4qIE0Wfno5/br8z2IXk32DpOfmKCex4xuJqus9DqAmgPkxJqnuKswhZXs0Fm4l/fYQqiLORM7OOn7WqlnTCgZGSfDFq4MsR/1f4eeOI35L10QceD3h1bMGS7fITSlMgb6SvR7MJ0AZOLV+envVSH38UQcSEPNVktFQ6zHs793ehWyGfU05jjbRB3VqceSd0J5c90MHOxSs9CgOgIwqbLMaG8S/M9LbKdpONHeZdUnFCQkT8/maz4BJGx55WfjGayA93l6DYXpODQp8Jz3aMfjafLim08g7H25v9eAYbXHoQaU/FtCKMzHbSPSJWvEaqP+1NQN/gVySfKcFSCRpyh6bkOkALB6y4iuEwIxpDNFULiQIssm+x6TN3k6/wBTs4CH5iLnxVFGSdzqjEAZpIZn/Q1DebnB7gQoL8cZer9M9p andec@CHARAN"
}

resource "aws_security_group" "t_sg" {
  name        = "t_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "t_sg"
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "tharun" {
  ami           = "ami-0fa91bc90632c73c9"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.t_sg.id]
  subnet_id = aws_subnet.tharun_public.id
  key_name = "tharun-key"
  associate_public_ip_address = true
  tags = {
    Name = "tharun"
  }
}

resource "aws_instance" "tharun_pvt" {
  ami           = "ami-0fa91bc90632c73c9"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.t_sg.id]
  subnet_id = aws_subnet.tharun_private.id
  key_name = "tharun-key"
  associate_public_ip_address = false
  tags = {
    Name = "tharun_pvt"
  }
}

