resource "aws_vpc" "aferrari-vpc" {
    cidr_block = "10.99.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"
}


resource "aws_subnet" "aferrari-subnet-1" {
    vpc_id = aws_vpc.aferrari-vpc.id
    cidr_block = "10.99.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}a"
}

resource "aws_subnet" "aferrari-subnet-2" {
    vpc_id = aws_vpc.aferrari-vpc.id
    cidr_block = "10.99.2.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}b"
}

  
# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet
resource "aws_internet_gateway" "aferrari-igw" {
    vpc_id = aws_vpc.aferrari-vpc.id
}

# create a custom route table for public subnets
# public subnets can reach to the internet buy using this
resource "aws_route_table" "aferrari-crt" {
    vpc_id = aws_vpc.aferrari-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aferrari-igw.id
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "aferrari-crta-subnet-1" {
    subnet_id = aws_subnet.aferrari-subnet-1.id
    route_table_id = aws_route_table.aferrari-crt.id
}

