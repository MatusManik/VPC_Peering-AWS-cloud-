# AWS Multi-VPC Architecture (Terraform)

# SUMMARY
A Terraform project that provisions a secure, multi-tenant AWS network for **Developers** and **Finance** teams. It builds two isolated VPCs connected via VPC Peering, hosting public EC2 instances and private MySQL databases.

# AWS Services & Tools Used
-> **Amazon VPC** – Isolated virtual networks (`10.1.0.0/16` & `10.2.0.0/16`)

-> **VPC Peering** – Direct, private connection between both VPCs

-> **Amazon EC2** – Virtual instances in public subnets

-> **Amazon RDS (MySQL)** – Databases hosted in private subnets

-> **Security Groups & NACLs** – Dual-layer network security

-> **LocalStack** – Local AWS environment for testing


# Quick Start:
_-_-_ bash/powershell

* terraform init 
* terraform apply

check infra:
* terraform state list
* terraform show

destroy infra:
* terraform destroy

code validation:
* terraform validate


# Credentials
Retrieve SSH key: terraform output -raw developers_ssh_private_key > key.pem