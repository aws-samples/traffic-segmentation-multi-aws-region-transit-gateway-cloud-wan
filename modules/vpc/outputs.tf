# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- modules/vpc/outputs.tf ---

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID."
}

output "transit_gateway_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  description = "Transit Gateway attachment ID."
}

