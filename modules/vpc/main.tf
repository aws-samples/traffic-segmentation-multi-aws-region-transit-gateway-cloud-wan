# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- modules/vpc/main.tf ---

# List of AZs available in the AWS Region
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

# VPC Data Source
data "aws_vpc" "vpc_data" {
  id = aws_vpc.vpc.id
}

# Default Security Group
# Ensuring that the default SG restricts all traffic (no ingress and egress rule). It is also not used in any resource
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.vpc.id
}

# Transit Gateway attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = aws_subnet.vpc_tgw_subnets.*.id
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.vpc.id
  ipv6_support       = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.vpc_name}-attachment"
  }
}

# Transit Gateway route table association
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.transit_gateway_rt_id
}

# Transit Gateway route table propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.transit_gateway_rt_id
}

# SUBNETS
# Private Subnets
resource "aws_subnet" "vpc_private_subnets" {
  count = var.number_azs

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, 0 + count.index)
  ipv6_cidr_block   = cidrsubnet(data.aws_vpc.vpc_data.ipv6_cidr_block, 8, 0 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${var.vpc_name}-${count.index + 1}"
  }
}

# Transit Gateway Subnets
resource "aws_subnet" "vpc_tgw_subnets" {
  count = var.number_azs

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, 3 + count.index)
  ipv6_cidr_block   = cidrsubnet(data.aws_vpc.vpc_data.ipv6_cidr_block, 8, 3 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tgw-subnet-${var.vpc_name}-${count.index + 1}"
  }
}

# ROUTE TABLES
# Private Route Table
resource "aws_route_table" "vpc_private_rt" {
  count = var.number_azs

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-rt-${var.vpc_name}-${count.index + 1}"
  }
}

resource "aws_route_table_association" "vpc_private_rt_assoc" {
  count = var.number_azs

  subnet_id      = aws_subnet.vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.vpc_private_rt[count.index].id
}

resource "aws_route" "tgw_route_ipv4" {
  count = var.number_azs

  route_table_id         = aws_route_table.vpc_private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.tgw_attachment
  ]
}

resource "aws_route" "tgw_route_ipv6" {
  count = var.number_azs

  route_table_id              = aws_route_table.vpc_private_rt[count.index].id
  destination_ipv6_cidr_block = "::/0"
  transit_gateway_id          = var.transit_gateway_id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.tgw_attachment
  ]
}

# Inspection Route Table
resource "aws_route_table" "vpc_tgw_rt" {
  count = var.number_azs

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tgw-rt-${var.vpc_name}-${count.index + 1}"
  }
}

resource "aws_route_table_association" "vpc_tgw_rt_assoc" {
  count = var.number_azs

  subnet_id      = aws_subnet.vpc_tgw_subnets[count.index].id
  route_table_id = aws_route_table.vpc_tgw_rt[count.index].id
}