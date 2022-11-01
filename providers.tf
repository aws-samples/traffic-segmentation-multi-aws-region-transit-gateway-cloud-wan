# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/providers.tf ---

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.28.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.36.0"
    }
  }
}

# Provider definition for N. Virginia Region 
provider "aws" {
  region = var.aws_regions.north_virginia
  alias  = "awsnvirginia"
}

# awscc provider definition needed for Cloud WAN resources
provider "awscc" {
  region = var.aws_regions.north_virginia
  alias  = "awsccnvirginia"
}

# Provider definitios for Ireland Region
provider "aws" {
  region = var.aws_regions.ireland
  alias  = "awsireland"
}