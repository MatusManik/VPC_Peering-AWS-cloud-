# AWS VPC Peering connection
# Enables direct private network routing between two Virtual Private Clouds (VPCs)
# Connects Developers VPC (requester) and Finance VPC (accepter)
resource "aws_vpc_peering_connection" "developers_finance_peering" {
  vpc_id      = aws_vpc.developers_vpc.id # Requester VPC ID
  peer_vpc_id = aws_vpc.finance_vpc.id    # Target/Accepter VPC ID

  # Automatically accept the peering connection (valid when both VPCs are in the same account/region)
  auto_accept = true

  tags = {
    Name        = "Developers-Finance-Peering"
    Project     = "VPC-Peering"
    Environment = "Lab"
  }
}