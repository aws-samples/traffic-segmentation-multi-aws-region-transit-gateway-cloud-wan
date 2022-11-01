# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- modules/vpc/variables.tf ---

variable "vpc_name" {
  type        = string
  description = "VPC name."
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block."
}

variable "number_azs" {
  type        = number
  description = "Number of AZs to use."
}

variable "transit_gateway_id" {
  type        = string
  description = "Transit Gateway ID."
}

variable "transit_gateway_rt_id" {
  type        = string
  description = "Transit Gateway route table ID."
}

