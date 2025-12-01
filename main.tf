#create vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy
  tags = {
    Name = var.vpc_tag
  }
}

#create public subnet
resource "aws_subnet" "tharun_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = var.subnet_tag
  }
}

#create private subnet
resource "aws_subnet" "tharun_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block_pvt
  tags = {
    Name = var.subnet_tag_pvt
  }
}

#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw_tag
  }
}

#create public route table
 resource"aws_route_table" "tharun_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.pb_rt_cidr_blk
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.pb_rt_tag
  }
} 

#create private route table
resource "aws_route_table" "tharun_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.pvt_rt_cidr_blk
    gateway_id = aws_nat_gateway.tharun.id
  }
  tags = {
    Name = var.pvt_rt_tag
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

#Attach Elastic IP
resource "aws_eip" "tharun" {
  tags = {
    Name = var.eip_tag
  }
}

#create NAT gateway
resource "aws_nat_gateway" "tharun" {
  allocation_id = aws_eip.tharun.id
  subnet_id     = aws_subnet.tharun_private.id
  tags = {
    Name = var.n_gw
  }
}

#create a Key pair
resource "aws_key_pair" "t_key" {
  key_name   = var.key
  public_key = var.p_key
}

#create Security group with inbound and outbound rules
resource "aws_security_group" "t_sg" {
  name        = var.sg
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = var.sg_tag
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

#create a public instance
resource "aws_instance" "tharun" {
  ami           = var.ami
  instance_type = var.i
  vpc_security_group_ids = [aws_security_group.t_sg.id]
  subnet_id = aws_subnet.tharun_public.id
  key_name = var.key_in
  associate_public_ip_address = var.x
  tags = {
    Name = var.n_pub_tag  }
}

#create a private instance
resource "aws_instance" "tharun_pvt" {
  ami           = var.ami_pvt
  instance_type = var.i
  vpc_security_group_ids = [aws_security_group.t_sg.id]
  subnet_id = aws_subnet.tharun_private.id
  key_name = var.key_in
  associate_public_ip_address = var.y
  tags = {
    Name = var.n_pvt_tag 
  }
}