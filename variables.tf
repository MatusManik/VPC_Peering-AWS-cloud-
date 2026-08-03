# TERRAFORM INPUT VARIABLES

# AWS Region Setting
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

# CIDR block defining the allowed administrator IP address for SSH ingress rules
variable "admin_IP_address" {
  description = "The IP address allowed to access the EC2 instances via SSH"
  type        = string
  default     = "203.0.113.50/32"
}

# AWS EC2 AMI Configuration
variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Example AMI ID for Amazon Linux 2 in eu-central-1
}