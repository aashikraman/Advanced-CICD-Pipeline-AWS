# Create a VPC in AWS
resource "aws_vpc" "project-vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"

tags = {
    Name = "CICD Project VPC"
}
}

# Create a public subnet in AWS
resource "aws_subnet" "public-subnet" {
    vpc_id = "${aws_vpc.project-vpc.id}"
    cidr_block = "${var.subnet_cidr}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

tags = {
    Name = "Public Subnet"
}
}

# Create a private subnet in AWS
resource "aws_subnet" "private-subnet" {
    vpc_id = "${aws_vpc.project-vpc.id}"
    cidr_block = "${var.subnet2_cidr}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

tags = {
    Name = "Private Subnet"
}
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.project-vpc.id}"
}

# Create a Route Table
resource "aws_route_table" "route" {
    vpc_id = "${aws_vpc.project-vps.id}"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
}

tags = {
    Name = "Route to internet"
}
}

# Associate internet gateway to public subnet
resource "aws_route_table_association" "rt1" {
    route_table_id = "${aws_route_table.route.id}"
    subnet_id = "${aws_subnet.public-subnet.id}"
}

# Create Security Group
resource "aws_security_group" "CICD-SG" {
    name = "CICD Project SG"
    description = "Security group for EC2 Instances in CICD Project"
    vpc_id = aws_vpc.project-vpc.id

ingress {
    description = "Allow ssh traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    description = "Custom TCP Traffic"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "CICD Project SG"
}
}

# Create Ansible EC2 Instance
resource "aws_instance" "Ansible-instance" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = "t2.micro"
  key_name                    = "DevOps"
  vpc_security_group_ids      = ["${aws_security_group.CICD-SG.id}"]
  subnet_id                   = "${aws_subnet.public-subnet.id}"
  associate_public_ip_address = true
tags = {
  Name = "Ansible Instance"
}
}

# Create Jenkins Master and 2 Agent EC2 Instances
resource "aws_instance" "JenkinsM-instance" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = "t2.micro"
  key_name                    = "DevOps"
  vpc_security_group_ids      = ["${aws_security_group.CICD-SG.id}"]
  subnet_id                   = "${aws_subnet.public-subnet.id}"
  associate_public_ip_address = true
  count                       = 3
tags = {
  Name = element(var.Jenkins_tags, count.index)
}
}
