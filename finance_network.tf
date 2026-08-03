# AWS VPC, Elastic IP (EIP), NAT Gateway & Networking
resource "aws_vpc" "finance_vpc" {
  # CIDR Block defining IP address range for Finance VPC (10.2.0.0/16)
  cidr_block           = "10.2.0.0/16"

  # Enable internal DNS resolution and hostname assignment
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Finance-Virtual-Network"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS VPC Subnets - Public & Private Subnets across Availability Zones
# Finance Public Subnet 1 (AZ: eu-central-1a)
resource "aws_subnet" "finance_public_subnet1" {
  vpc_id                  = aws_vpc.finance_vpc.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true # Automatically assign public IP to instances in this subnet

  tags = {
    Name        = "Finance-Public-Subnet-One"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Finance Public Subnet 2 (AZ: eu-central-1b)
resource "aws_subnet" "finance_public_subnet2" {
  vpc_id                  = aws_vpc.finance_vpc.id
  cidr_block              = "10.2.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true # Automatically assign public IP to instances in this subnet

  tags = {
    Name        = "Finance-Public-Subnet-Two"
    Project     = "VPC-peering"
    Environment = "Lab"
  }
}

# Finance Private Subnet 1 (AZ: eu-central-1a)
resource "aws_subnet" "finance_private_subnet1" {
  vpc_id                  = aws_vpc.finance_vpc.id
  cidr_block              = "10.2.3.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false # Isolated subnet (no public IP assigned)

  tags = {
    Name        = "Finance-Private-Subnet-One"
    Project     = "VPC-peering"
    Environment = "Lab"
  }
}

# Finance Private Subnet 2 (AZ: eu-central-1b)
resource "aws_subnet" "finance_private_subnet2" {
  vpc_id                  = aws_vpc.finance_vpc.id
  cidr_block              = "10.2.4.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false # Isolated subnet (no public IP assigned)

  tags = {
    Name        = "Finance-Private-Subnet-Two"
    Project     = "VPC-peering"
    Environment = "Lab"
  }
}

# AWS Internet Gateway (IGW)
# Enables public network connectivity for public subnets
resource "aws_internet_gateway" "finance_igw" {
  vpc_id = aws_vpc.finance_vpc.id

  tags = {
    Name = "Finance-Internet-Gateway"
  }
}

# AWS Elastic IP (EIP) & NAT Gateway
# Static public IP address allocation for NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.finance_igw]
  tags = {
    Name = "main-nat-eip"
  }
}

# Managed NAT Gateway placed in Public Subnet 1
resource "aws_nat_gateway" "finance_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.finance_public_subnet1.id

  tags = {
    Name = "Finance-NAT-Gateway"
  }

  depends_on = [aws_internet_gateway.finance_igw]
}

# AWS Route Tables
# Public Route Table: Routes internet traffic via IGW & peer traffic via VPC Peering
resource "aws_route_table" "finance_public_rt" {
  vpc_id = aws_vpc.finance_vpc.id

  # Default route (0.0.0.0/0) to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.finance_igw.id
  }

  # Route traffic targeting Developers VPC (10.1.0.0/16) through VPC Peering
  route {
    cidr_block                = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.developers_finance_peering.id
  }
}

# Private Route Table: Routes outgoing internet traffic through the NAT Gateway
resource "aws_route_table" "finance_private_rt" {
  vpc_id = aws_vpc.finance_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.finance_nat_gateway.id
  }
}

# AWS Route Table Associations
# Associate Public Subnet 1 to Public Route Table
resource "aws_route_table_association" "finance_rt_association1" {
  route_table_id = aws_route_table.finance_public_rt.id
  subnet_id      = aws_subnet.finance_public_subnet1.id
}

# Associate Public Subnet 2 to Public Route Table
resource "aws_route_table_association" "finance_rt_association2" {
  route_table_id = aws_route_table.finance_public_rt.id
  subnet_id      = aws_subnet.finance_public_subnet2.id
}

# Associate Private Subnet 1 to Private Route Table (Routes out via NAT)
resource "aws_route_table_association" "finance_rt_private_association1" {
  route_table_id = aws_route_table.finance_private_rt.id
  subnet_id      = aws_subnet.finance_private_subnet1.id
}

# Associate Private Subnet 2 to Private Route Table (Routes out via NAT)
resource "aws_route_table_association" "finance_rt_private_association2" {
  route_table_id = aws_route_table.finance_private_rt.id
  subnet_id      = aws_subnet.finance_private_subnet2.id
}