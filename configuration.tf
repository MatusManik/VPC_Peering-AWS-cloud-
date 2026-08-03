# TERRAFORM & PROVIDER CONFIGURATION
# Target Environment: LocalStack (Local AWS Cloud Emulation)

# Define required Terraform version and provider requirements
terraform {
  required_version = ">=1.2"

  required_providers {
    # Official AWS Provider from HashiCorp Registry
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

# AWS Provider configuration redirected to LocalStack
provider "aws" {
  region = var.aws_region

  # Dummy credentials required by the AWS provider (safe for local LocalStack usage)
  access_key = "test"
  secret_key = "test"

  # Skip AWS cloud-specific checks and API validation for local emulation
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  # Force path-style S3 URLs (required for LocalStack S3 compatibility)
  s3_use_path_style = true

  # Redirect AWS API calls to the local LocalStack endpoint (port 4566)
  # Services configured: AWS EC2, AWS STS (Security Token Service), AWS RDS
  endpoints {
    ec2 = "http://localhost:4566"
    sts = "http://localhost:4566"
    rds = "http://localhost:4566"
  }
}