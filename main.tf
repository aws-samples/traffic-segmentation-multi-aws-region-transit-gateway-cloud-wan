# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/main.tf ---

# ---------- HUB AND SPOKE ARCHITECTURE (NORTH VIRGINIA - us-east-1) ----------
# AWS Transit Gateway
resource "aws_ec2_transit_gateway" "nvirginia_tgw" {
  provider = aws.awsnvirginia

  description     = "North Virginia TGW"
  amazon_side_asn = var.transit_gateway_asn.north_virginia

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "nvriginia-tgw-${var.identifier}"
  }
}

# Spoke VPCs (Prod and Non-Prod)
module "nvirginia_vpcs" {
  providers = { aws = aws.awsnvirginia }
  for_each  = var.nvirginia_spoke_vpcs
  source    = "./modules/vpc"

  vpc_name              = each.key
  cidr_block            = each.value.cidr_block
  number_azs            = each.value.number_azs
  transit_gateway_id    = aws_ec2_transit_gateway.nvirginia_tgw.id

  # Transit Gateway route table association done in the module
  transit_gateway_rt_id = each.value.type == "prod" ? aws_ec2_transit_gateway_route_table.prod_tgw_rt.id : aws_ec2_transit_gateway_route_table.nonprod_tgw_rt.id
}

# Transit Gateway Route Table (Prod)
resource "aws_ec2_transit_gateway_route_table" "prod_tgw_rt" {
  provider = aws.awsnvirginia

  transit_gateway_id = aws_ec2_transit_gateway.nvirginia_tgw.id

  tags = {
    Name = "prod-rt-${var.identifier}"
    env  = "prod"
  }
}

# Transit Gateway Route Table (Non-Prod)
resource "aws_ec2_transit_gateway_route_table" "nonprod_tgw_rt" {
  provider = aws.awsnvirginia

  transit_gateway_id = aws_ec2_transit_gateway.nvirginia_tgw.id

  tags = {
    Name = "nonprod-rt-${var.identifier}"
    env  = "nonprod"
  }
}

# Transit Gateway policy table (and association to the peering)
resource "aws_ec2_transit_gateway_policy_table" "nvirginia_tgw_policy_table" {
    provider = aws.awsnvirginia

    transit_gateway_id = aws_ec2_transit_gateway.nvirginia_tgw.id

    tags = {
        Name = "tgw-policy-table-us-east-1-${var.identifier}"
    }
}

resource "aws_ec2_transit_gateway_policy_table_association" "nvirginia_tgw_policy_table_association" {
    provider = aws.awsnvirginia

    transit_gateway_attachment_id = aws_networkmanager_transit_gateway_peering.cwan_nvirginia_peering.transit_gateway_peering_attachment_id
    transit_gateway_policy_table_id = aws_ec2_transit_gateway_policy_table.nvirginia_tgw_policy_table.id
}

# Cloud WAN peering
resource "aws_networkmanager_transit_gateway_peering" "cwan_nvirginia_peering" {
    provider = aws.awsnvirginia

    core_network_id = awscc_networkmanager_core_network.core_network.core_network_id
    transit_gateway_arn = aws_ec2_transit_gateway.nvirginia_tgw.arn
}

# Transit Gateway Route Table attachments (prod and nonprod)
resource "aws_networkmanager_transit_gateway_route_table_attachment" "nvirginia_cwan_tgw_rt_attachment_prod" {
    provider = aws.awsnvirginia

    peering_id = aws_networkmanager_transit_gateway_peering.cwan_nvirginia_peering.id
    transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.prod_tgw_rt.arn

    tags = {
        Name = "prod-us-east-1-tgw-rt-attachment"
        env = "prod"
    }
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "nvirginia_cwan_tgw_rt_attachment_nonprod" {
    provider = aws.awsnvirginia

    peering_id = aws_networkmanager_transit_gateway_peering.cwan_nvirginia_peering.id
    transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.nonprod_tgw_rt.arn

    tags = {
        Name = "nonprod-us-east-1-tgw-rt-attachment"
        env = "nonprod"
    }
}

# ---------- HUB AND SPOKE ARCHITECTURE (NORTH VIRGINIA - us-east-1) ----------
# Transit Gateway
resource "aws_ec2_transit_gateway" "ireland_tgw" {
  provider = aws.awsireland

  description     = "Ireland TGW"
  amazon_side_asn = var.transit_gateway_asn.ireland

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "ireland-tgw-${var.identifier}"
  }
}

# Spoke VPCs (Prod and Non-Prod)
module "ireland_vpcs" {
  providers = { aws = aws.awsireland }
  for_each  = var.ireland_spoke_vpcs
  source    = "./modules/vpc"

  vpc_name              = each.key
  cidr_block            = each.value.cidr_block
  number_azs            = each.value.number_azs
  transit_gateway_id    = aws_ec2_transit_gateway.ireland_tgw.id

  # Transit Gateway route table association done in the module
  transit_gateway_rt_id = each.value.type == "prod" ? aws_ec2_transit_gateway_route_table.prod_tgw_rt_ireland.id : aws_ec2_transit_gateway_route_table.nonprod_tgw_rt_ireland.id
}

# Transit Gateway Route Table (Prod)
resource "aws_ec2_transit_gateway_route_table" "prod_tgw_rt_ireland" {
  provider = aws.awsireland

  transit_gateway_id = aws_ec2_transit_gateway.ireland_tgw.id

  tags = {
    Name = "prod-rt-${var.identifier}"
    env  = "prod"
  }
}

# Transit Gateway Route Table (Non-Prod)
resource "aws_ec2_transit_gateway_route_table" "nonprod_tgw_rt_ireland" {
  provider = aws.awsireland

  transit_gateway_id = aws_ec2_transit_gateway.ireland_tgw.id

  tags = {
    Name = "nonprod-rt-${var.identifier}"
    env  = "nonprod"
  }
}

# Transit Gateway policy table (and association to the peering)
resource "aws_ec2_transit_gateway_policy_table" "ireland_tgw_policy_table" {
    provider = aws.awsireland

    transit_gateway_id = aws_ec2_transit_gateway.ireland_tgw.id

    tags = {
        Name = "tgw-policy-table-eu-west-1-${var.identifier}"
    }
}

resource "aws_ec2_transit_gateway_policy_table_association" "ireland_tgw_policy_table_association" {
    provider = aws.awsireland

    transit_gateway_attachment_id = aws_networkmanager_transit_gateway_peering.cwan_ireland_peering.transit_gateway_peering_attachment_id
    transit_gateway_policy_table_id = aws_ec2_transit_gateway_policy_table.ireland_tgw_policy_table.id
}

# Cloud WAN peering
resource "aws_networkmanager_transit_gateway_peering" "cwan_ireland_peering" {
    provider = aws.awsireland

    core_network_id = awscc_networkmanager_core_network.core_network.core_network_id
    transit_gateway_arn = aws_ec2_transit_gateway.ireland_tgw.arn
}

# Transit Gateway Route Table attachments (prod and nonprod)
resource "aws_networkmanager_transit_gateway_route_table_attachment" "ireland_cwan_tgw_rt_attachment_prod" {
    provider = aws.awsireland

    peering_id = aws_networkmanager_transit_gateway_peering.cwan_ireland_peering.id
    transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.prod_tgw_rt_ireland.arn

    tags = {
        Name = "prod-eu-west-1-tgw-rt-attachment"
        env = "prod"
    }
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "ireland_cwan_tgw_rt_attachment_nonprod" {
    provider = aws.awsireland

    peering_id = aws_networkmanager_transit_gateway_peering.cwan_ireland_peering.id
    transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.nonprod_tgw_rt_ireland.arn

    tags = {
        Name = "nonprod-eu-west-1-tgw-rt-attachment"
        env = "nonprod"
    }
}

# ---------- CLOUD WAN RESOURCES ----------
# Global Network
resource "awscc_networkmanager_global_network" "global_network" {
  description = "Global Network"

  tags = [{
    key   = "Name"
    value = "Global Network"
  }]
}

# Core Network (policy in cwan.tf file)
resource "awscc_networkmanager_core_network" "core_network" {
  description       = "Core Network"
  global_network_id = awscc_networkmanager_global_network.global_network.id
  policy_document   = jsonencode(jsondecode(data.aws_networkmanager_core_network_policy_document.policy.json))

  tags = [{
    key   = "Name"
    value = "Core Network"
  }]
}

# 