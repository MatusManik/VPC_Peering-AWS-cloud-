# AWS EC2 (Elastic Compute Cloud)

# AWS EC2 Instance
# Virtual server deployed in the first Developers public subnet
resource "aws_instance" "developers_instance_sb1" {
  ami                    = var.ami_id                                         # Amazon Machine Image (AMI) defining OS/software
  instance_type          = var.instance_type                                 # Virtual machine size/hardware specification
  subnet_id              = aws_subnet.developers_public_subnet1.id           # Target subnet where instance is launched
  key_name               = aws_key_pair.developers_key_pair.key_name        # SSH Key Pair name for secure instance access
  vpc_security_group_ids = [aws_security_group.developers_security_group.id] # Firewall rules / Security Group attached

  tags = {
    Name        = "Developers-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Virtual server deployed in the second Developers public subnet
resource "aws_instance" "developers_instance_sb2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.developers_public_subnet2.id
  key_name               = aws_key_pair.developers_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.developers_security_group.id]
  
  tags = {
    Name        = "Developers-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS EC2 Instance
# Virtual server deployed in the first Finance public subnet
resource "aws_instance" "finance_instance_sb1" {
  ami                    = var.ami_id                                      # Amazon Machine Image (AMI) defining OS/software
  instance_type          = var.instance_type                             # Virtual machine size/hardware specification
  subnet_id              = aws_subnet.finance_public_subnet1.id           # Target subnet where instance is launched
  key_name               = aws_key_pair.finance_key_pair.key_name        # SSH Key Pair name for secure instance access
  vpc_security_group_ids = [aws_security_group.finance_security_group.id] # Firewall rules / Security Group attached

  tags = {
    Name        = "Finance-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# Virtual server deployed in the second Finance public subnet
resource "aws_instance" "finance_instance_sb2" {
  ami                    = var.ami_id                                      
  instance_type          = var.instance_type                             
  subnet_id              = aws_subnet.finance_public_subnet2.id          
  key_name               = aws_key_pair.finance_key_pair.key_name        
  vpc_security_group_ids = [aws_security_group.finance_security_group.id]

  tags = {
    Name        = "Finance-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}