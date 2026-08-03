# AWS VPC (Virtual Private Cloud) & Networking
resource "aws_vpc" "developers_vpc" {
  # CIDR Block defining the IP address range for the Developers VPC
  cidr_block           = "10.1.0.0/16"

  # Enable internal DNS resolution and hostname assignment
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Developers-Virtual-Network"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS VPC Subnets - Public & Private Subnets across multiple Availability Zones
# Developers Public Subnet 1 (AZ: eu-central-1a)
resource "aws_subnet" "developers_public_subnet1" {
  vpc_id                  = aws_vpc.developers_vpc.id
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true # Automatically assign public IP to instances in this subnet

  tags = {
    Name        = "Developers-Public-Subnet-One"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Developers Public Subnet 2 (AZ: eu-central-1b)
resource "aws_subnet" "developers_public_subnet2" {
  vpc_id                  = aws_vpc.developers_vpc.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true # Automatically assign public IP to instances in this subnet

  tags = {
    Name        = "Developers-Public-Subnet-Two"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Developers Private Subnet 1 (AZ: eu-central-1a)
resource "aws_subnet" "developers_private_subnet1" {
  vpc_id                  = aws_vpc.developers_vpc.id
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = false # Isolated subnet (no public IP assigned)

  tags = {
    Name        = "Developers-Private-Subnet-One"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Developers Private Subnet 2 (AZ: eu-central-1b)
resource "aws_subnet" "developers_private_subnet2" {
  vpc_id                  = aws_vpc.developers_vpc.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = false # Isolated subnet (no public IP assigned)

  tags = {
    Name        = "Developers-Private-Subnet-Two"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS Internet Gateway (IGW)
# Allows communication between resources in public subnets and the internet
resource "aws_internet_gateway" "developers_igw" {
  vpc_id = aws_vpc.developers_vpc.id

  tags = {
    Name = "Developers-Internet-Gateway"
  }
}

# AWS Route Tables
# Defines routing rules for network traffic leaving the subnets
# Route table for public subnets
resource "aws_route_table" "developers_public_rt" {
  vpc_id = aws_vpc.developers_vpc.id

  # Default route (0.0.0.0/0) to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.developers_igw.id
  }

  # Peering route: Route traffic destined for Finance VPC (10.2.0.0/16) through VPC Peering
  route {
    cidr_block                = "10.2.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.developers_finance_peering.id
  }
}

# Route table for private subnets (no direct route to Internet Gateway)
resource "aws_route_table" "developers_private_rt" {
  vpc_id = aws_vpc.developers_vpc.id
}

# AWS Route Table Associations
# Associate Public Subnet 1 to Public Route Table
resource "aws_route_table_association" "developers_rt_association1" {
  route_table_id = aws_route_table.developers_public_rt.id
  subnet_id      = aws_subnet.developers_public_subnet1.id
}

# Associate Public Subnet 2 to Public Route Table
resource "aws_route_table_association" "developers_rt_association2" {
  route_table_id = aws_route_table.developers_public_rt.id
  subnet_id      = aws_subnet.developers_public_subnet2.id
}

# Associate Private Subnet 1 to Private Route Table
resource "aws_route_table_association" "developers_rt_private_association1" {
  route_table_id = aws_route_table.developers_private_rt.id
  subnet_id      = aws_subnet.developers_private_subnet1.id
}

# Associate Private Subnet 2 to Private Route Table
resource "aws_route_table_association" "developers_rt_private_association2" {
  route_table_id = aws_route_table.developers_private_rt.id
  subnet_id      = aws_subnet.developers_private_subnet2.id
}