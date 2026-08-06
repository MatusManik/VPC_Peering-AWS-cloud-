# TERRAFORM OUTPUTS

# AWS EC2 Output Values
# Public IP addresses assigned to the Developers EC2 instances
output "developers_ec2_1_public_ip" {
  description = "Public IP address for first Developers EC2 instance"
  value       = aws_instance.developers_instance_sb1.public_ip
}

output "developers_ec2_2_public_ip" {
  description = "Public IP address for second Developers EC2 instance"
  value       = aws_instance.developers_instance_sb2.public_ip
}

# Public IP addresses assigned to the Finance EC2 instances
output "finance_ec2_1_public_ip" {
  description = "Public IP address for first Finance EC2 instance"
  value       = aws_instance.finance_instance_sb1.public_ip
}

output "finance_ec2_2_public_ip" {
  description = "Public IP address for second Finance EC2 instance"
  value       = aws_instance.finance_instance_sb2.public_ip
}

# AWS RDS (Database) Output Values
# Connection endpoint for the Developers MySQL RDS instance
output "developers_rds_endpoint" {
  description = "Endpoint for Developers RDS database"
  value       = aws_db_instance.developers_rds_instance.endpoint
}

# Connection endpoint for the Finance MySQL RDS instance
output "finance_rds_endpoint" {
  description = "Endpoint for Finance RDS database"
  value       = aws_db_instance.finance_rds_instance.endpoint
}

# Randomly generated master password for RDS instances
# Marked as sensitive to prevent plain-text display in CLI logs or console output
output "rds_generated_password" {
  description = "Password automatically generated for RDS instances"
  value       = random_password.rds_password.result
  sensitive   = true # Hides the output in the terminal to prevent accidental exposure of sensitive information
}