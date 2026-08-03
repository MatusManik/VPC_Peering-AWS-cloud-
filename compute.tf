# AWS EC2 (Elastic Compute Cloud)

# AWS EC2 Instance
# Virtual server deployed in the Developers public subnet
resource "aws_instance" "developers_instance" {
  ami                    = var.ami_id                                         # Amazon Machine Image (AMI) defining OS/software
  instance_type          = "t3.micro"                                         # Virtual machine size/hardware specification
  subnet_id              = aws_subnet.developers_public_subnet1.id           # Target subnet where instance is launched
  key_name               = aws_key_pair.developers_key_pair.key_name        # SSH Key Pair name for secure instance access
  vpc_security_group_ids = [aws_security_group.developers_security_group.id] # Firewall rules / Security Group attached

  tags = {
    Name        = "Developers-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}

# AWS EC2 Instance
# Virtual server deployed in the Finance public subnet
resource "aws_instance" "finance_instance" {
  ami                    = var.ami_id                                      # Amazon Machine Image (AMI) defining OS/software
  instance_type          = "t3.micro"                                      # Virtual machine size/hardware specification
  subnet_id              = aws_subnet.finance_public_subnet1.id           # Target subnet where instance is launched
  key_name               = aws_key_pair.finance_key_pair.key_name        # SSH Key Pair name for secure instance access
  vpc_security_group_ids = [aws_security_group.finance_security_group.id] # Firewall rules / Security Group attached

  tags = {
    Name        = "Finance-EC2-Instance"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}