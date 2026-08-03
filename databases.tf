# AWS RDS (Relational Database Service)
# Database Subnet Groups & MySQL Database Instances Configuration

# AWS RDS Subnet Group - Developers
# Defines a collection of private subnets where the Developers DB can be placed
resource "aws_db_subnet_group" "developers_rds_subnet_group" {
  name       = "developers-rds-subnet-group"
  subnet_ids = [
    aws_subnet.developers_private_subnet1.id,
    aws_subnet.developers_private_subnet2.id
  ]

  tags = {
    Name = "rds-developers-subnet-group"
  }
}

# AWS RDS Subnet Group - Finance
# Defines a collection of private subnets where the Finance DB can be placed
resource "aws_db_subnet_group" "finance_rds_subnet_group" {
  name       = "finance-rds-subnet-group"
  subnet_ids = [
    aws_subnet.finance_private_subnet1.id,
    aws_subnet.finance_private_subnet2.id
  ]

  tags = {
    Name = "rds-finance-subnet-group"
  }
}

# AWS RDS Database Instance - Developers MySQL Database
resource "aws_db_instance" "developers_rds_instance" {
  # Database engine settings
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "developersdb"

  # Access credentials (password dynamically generated via random_password resource)
  username          = "admin"
  password          = random_password.rds_password.result

  # Networking & Security
  db_subnet_group_name   = aws_db_subnet_group.developers_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.developers_rds_security_group.id]
  publicly_accessible    = false

  skip_final_snapshot    = true

  tags = {
    Name        = "Developers-RDS-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS RDS Database Instance - Finance MySQL Database
resource "aws_db_instance" "finance_rds_instance" {
  # Database engine settings
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "financedb"

  # Access credentials (password dynamically generated via random_password resource)
  username          = "admin"
  password          = random_password.rds_password.result

  # Networking & Security
  db_subnet_group_name   = aws_db_subnet_group.finance_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.finance_rds_security_group.id]
  publicly_accessible    = false

  skip_final_snapshot    = true

  tags = {
    Name        = "Finance-RDS-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}