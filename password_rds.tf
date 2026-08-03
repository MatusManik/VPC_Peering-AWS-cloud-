# Random Password Generator
# Generates a secure database password used across RDS instances
resource "random_password" "rds_password" {
  length           = 16                        # Sets total password length to 16 characters
  special          = true                      # Enables special characters in the password
  override_special = "!#$%&*()-_=+[]{}<>:?"   # Custom list of allowed special characters
}