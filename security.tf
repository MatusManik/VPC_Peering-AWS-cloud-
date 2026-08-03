# AWS EC2 Key Pairs, Network ACLs (NACL), & Security Groups

# AWS EC2 Key Pair - Developers
resource "aws_key_pair" "developers_key_pair" {
  key_name   = "developers-key-pair"
  public_key = file("./Keys/developers-key-pair.pub")
}

# AWS Network ACL (NACL) - Developers Public Subnets
# Stateless subnet-level firewall controlling inbound and outbound traffic
resource "aws_network_acl" "developers_access_control_list" {
  vpc_id     = aws_vpc.developers_vpc.id
  subnet_ids = [
    aws_subnet.developers_public_subnet1.id,
    aws_subnet.developers_public_subnet2.id,
  ]

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443 # Allow inbound HTTPS traffic
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "${var.admin_IP_address}"
    from_port  = 22
    to_port    = 22 # Allow inbound SSH access only from admin IP
  }

  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535 # Allow return traffic on ephemeral ports (required for stateless NACL)
  }

  ingress {
    rule_no    = 130
    protocol   = "-1" # All protocols
    action     = "allow"
    cidr_block = "10.2.0.0/16"
    from_port  = 0
    to_port    = 0 # Allow all inbound traffic from Finance VPC via Peering
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443 # Allow outbound HTTPS traffic
  }

  egress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "${var.admin_IP_address}"
    from_port  = 22
    to_port    = 22 # Allow outbound SSH responses to admin IP
  }

  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535 # Allow outbound responses via ephemeral ports
  }

  egress {
    rule_no    = 130
    protocol   = "-1" # All protocols
    action     = "allow"
    cidr_block = "10.2.0.0/16"
    from_port  = 0
    to_port    = 0 # Allow all outbound traffic to Finance VPC via Peering
  }
}

# AWS EC2 Key Pair - Finance
resource "aws_key_pair" "finance_key_pair" {
  key_name   = "finance-key-pair"
  public_key = file("./Keys/finance-key-pair.pub")
}

# AWS Network ACL (NACL) - Finance Public Subnets
# Stateless subnet-level firewall controlling inbound and outbound traffic
resource "aws_network_acl" "finance_access_control_list" {
  vpc_id     = aws_vpc.finance_vpc.id
  subnet_ids = [
    aws_subnet.finance_public_subnet1.id,
    aws_subnet.finance_public_subnet2.id,
  ]

  # Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443 # Allow inbound HTTPS traffic
  }

  ingress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535 # Allow return traffic on ephemeral ports
  }

  ingress {
    rule_no    = 130
    protocol   = "-1" # All protocols
    action     = "allow"
    cidr_block = "10.1.0.0/16"
    from_port  = 0
    to_port    = 0 # Allow all inbound traffic from Developers VPC via Peering
  }

  # Outbound Rules
  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443 # Allow outbound HTTPS traffic
  }

  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535 # Allow outbound responses via ephemeral ports
  }

  egress {
    rule_no    = 130
    protocol   = "-1" # All protocols
    action     = "allow"
    cidr_block = "10.1.0.0/16"
    from_port  = 0
    to_port    = 0 # Allow all outbound traffic to Developers VPC via Peering
  }
}

# AWS Security Group - Developers EC2 Instances
# Stateful instance-level firewall controlling inbound and outbound EC2 traffic
resource "aws_security_group" "developers_security_group" {
  name        = "developers-security-group"
  description = "Allow SSH and HTTPS inbound traffic and also allow traffic from Finance VPC"
  vpc_id      = aws_vpc.developers_vpc.id

  # Inbound Rules
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_IP_address] # Restricted SSH access to admin IP
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Public HTTPS access
  }

  ingress {
    description = "Allow traffic from Finance VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.2.0.0/16"] # Allow all incoming traffic from Finance VPC
  }

  # Outbound Rules
  egress {
    description = "ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Unrestricted outbound internet access
  }

  egress {
    description = "Allow traffic to Finance VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.2.0.0/16"] # Allow all outgoing traffic to Finance VPC
  }
}

# AWS Security Group - Finance EC2 Instances
# Stateful instance-level firewall controlling inbound and outbound EC2 traffic
resource "aws_security_group" "finance_security_group" {
  name        = "finance-security-group"
  description = "Allow SSH and HTTPS inbound traffic and also allow traffic from Developers VPC"
  vpc_id      = aws_vpc.finance_vpc.id

  # Inbound Rules
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_IP_address] # Restricted SSH access to admin IP
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Public HTTPS access
  }

  ingress {
    description = "Allow traffic from Developers VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"] # Allow all incoming traffic from Developers VPC
  }

  # Outbound Rules
  egress {
    description = "ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Unrestricted outbound internet access
  }

  egress {
    description = "Allow traffic to Developers VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"] # Allow all outgoing traffic to Developers VPC
  }
}

# AWS Security Group - Developers RDS Database
# Stateful firewall restricting database access strictly to the Developers VPC
resource "aws_security_group" "developers_rds_security_group" {
  name        = "Developers-RDS-security-group"
  description = "Allow MySQL traffic from Developers VPC"
  vpc_id      = aws_vpc.developers_vpc.id

  # Inbound Rule: Allow MySQL requests (port 3306) only within Developers VPC
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  # Outbound Rule: Restrict outbound responses to Developers VPC
  egress {
    description = "ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }
}

# AWS Security Group - Finance RDS Database
# Stateful firewall restricting database access strictly to the Finance VPC
resource "aws_security_group" "finance_rds_security_group" {
  name        = "Finance-RDS-security-group"
  description = "Allow MySQL traffic from Finance VPC"
  vpc_id      = aws_vpc.finance_vpc.id

  # Inbound Rule: Allow MySQL requests (port 3306) only within Finance VPC
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }

  # Outbound Rule: Restrict outbound responses to Finance VPC
  egress {
    description = "ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.2.0.0/16"]
  }
}