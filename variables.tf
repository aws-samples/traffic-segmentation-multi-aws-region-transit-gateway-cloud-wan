# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/variables.tf ---

# Project identifier
variable "identifier" {
  type        = string
  description = "Project Identifier."

  default = "traffic-segmentation-tgw-cwan"
}

# AWS Regions to use in this example
variable "aws_regions" {
  type        = map(string)
  description = "AWS regions."

  default = {
    north_virginia = "us-east-1"
    ireland        = "eu-west-1"
  }
}

# Amazon Side ASNs to use in the Transit Gateways
variable "transit_gateway_asn" {
  type        = map(string)
  description = "Amazon Side ASNs to apply in the Transit Gateways."

  default = {
    north_virginia = 65050
    ireland        = 65051
  }
}

# Definition of the VPCs to create in N. Virginia Region
variable "nvirginia_spoke_vpcs" {
  type        = any
  description = "Information about the VPCs to create in us-east-1."

  default = {
    "non-prod-1" = {
      type       = "nonprod"
      number_azs = 2
      cidr_block = "10.0.2.0/24"
    }
    "non-prod-2" = {
      type       = "nonprod"
      number_azs = 2
      cidr_block = "10.0.3.0/24"
    }
    "prod" = {
      type       = "prod"
      number_azs = 2
      cidr_block = "10.0.0.0/24"
    }
    "prod-2" = {
      type       = "prod"
      number_azs = 2
      cidr_block = "10.0.1.0/24"
    }
  }
}

# Definition of the VPCs to create in Ireland Region
variable "ireland_spoke_vpcs" {
  type        = any
  description = "Information about the VPCs to create in eu-west-1."

  default = {
    "non-prod-1" = {
      type       = "nonprod"
      number_azs = 2
      cidr_block = "10.1.2.0/24"
    }
    "non-prod-2" = {
      type       = "nonprod"
      number_azs = 2
      cidr_block = "10.1.3.0/24"
    }
    "prod-1" = {
      type       = "prod"
      number_azs = 2
      cidr_block = "10.1.0.0/24"
    }
    "prod-2" = {
      type       = "prod"
      number_azs = 2
      cidr_block = "10.1.1.0/24"
    }
  }
}