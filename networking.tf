resource "aws_vpc" "aferrari-vpc" {
    cidr_block            = "10.99.0.0/16"
    enable_dns_support    = "true"
    enable_dns_hostnames  = "true"
    enable_classiclink    = "false"
    instance_tenancy      = "default"
}

resource "aws_subnet" "aferrari-subnet-1-private" {
    vpc_id                  = aws_vpc.aferrari-vpc.id
    cidr_block              = "10.99.100.0/24"
    map_public_ip_on_launch = "false"
    availability_zone       = "${var.region}a"
}

resource "aws_subnet" "aferrari-subnet-2-private" {
    vpc_id                  = aws_vpc.aferrari-vpc.id
    cidr_block              = "10.99.200.0/24"
    map_public_ip_on_launch = "false"
    availability_zone       = "${var.region}b"
}

resource "aws_subnet" "aferrari-subnet-1-public" {
    vpc_id                  = aws_vpc.aferrari-vpc.id
    cidr_block              = "10.99.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone       = "${var.region}a"
}

resource "aws_subnet" "aferrari-subnet-2-public" {
    vpc_id                  = aws_vpc.aferrari-vpc.id
    cidr_block              = "10.99.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone       = "${var.region}b"
}

# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet for public subnets
resource "aws_internet_gateway" "aferrari-igw" {
    vpc_id        = aws_vpc.aferrari-vpc.id
}

# create an EGW (Elastic IP) for NAT Gateway
resource "aws_eip" "natgw" {
    vpc           = true
}

# create an NAT-GW (NAT Gateway)
# It enables your vpc to connect to the internet for private subnets
resource "aws_nat_gateway" "aferrari-natgw-subnet-1" {
    allocation_id = aws_eip.natgw.id
    subnet_id     = aws_subnet.aferrari-subnet-1-public.id

    depends_on = [aws_internet_gateway.aferrari-igw]

}

# create a custom route table for public subnets
resource "aws_route_table" "aferrari-crt-public" {
    vpc_id = aws_vpc.aferrari-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aferrari-igw.id
    }
}

resource "aws_route_table" "aferrari-crt-private" {
    vpc_id = aws_vpc.aferrari-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.aferrari-natgw-subnet-1.id
    }
}

# route table association for the private subnets A
resource "aws_route_table_association" "aferrari-crta-private-1-a" {
    subnet_id = aws_subnet.aferrari-subnet-1-private.id
    route_table_id = aws_route_table.aferrari-crt-private.id
}

# route table association for the private subnets B
resource "aws_route_table_association" "aferrari-crta-private-2-a" {
    subnet_id = aws_subnet.aferrari-subnet-2-private.id
    route_table_id = aws_route_table.aferrari-crt-private.id
}

# route table association for the public subnets A
resource "aws_route_table_association" "aferrari-crta-public-1-b" {
    subnet_id = aws_subnet.aferrari-subnet-1-public.id
    route_table_id = aws_route_table.aferrari-crt-public.id
}

# route table association for the public subnets B
resource "aws_route_table_association" "aferrari-crta-public-2-b" {
    subnet_id = aws_subnet.aferrari-subnet-2-public.id
    route_table_id = aws_route_table.aferrari-crt-public.id
}