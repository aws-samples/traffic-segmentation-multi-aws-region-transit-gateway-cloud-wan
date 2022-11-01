# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/outputs.tf ---

output "cloud_wan" {
  description = "Cloud WAN resources."
  value = {
    global_network = awscc_networkmanager_global_network.global_network.id
    core_network   = awscc_networkmanager_core_network.core_network.core_network_id
    peering = {
      nvirginia = aws_networkmanager_transit_gateway_peering.cwan_nvirginia_peering.id
      ireland = aws_networkmanager_transit_gateway_peering.cwan_ireland_peering.id
    }
    tgw_rt_attachment = {
      nvirginia = {
        prod = aws_networkmanager_transit_gateway_route_table_attachment.nvirginia_cwan_tgw_rt_attachment_prod.id
        nonprod = aws_networkmanager_transit_gateway_route_table_attachment.nvirginia_cwan_tgw_rt_attachment_nonprod.id
      }
      ireland = {
        prod = aws_networkmanager_transit_gateway_route_table_attachment.ireland_cwan_tgw_rt_attachment_prod.id
        nonprod = aws_networkmanager_transit_gateway_route_table_attachment.ireland_cwan_tgw_rt_attachment_nonprod.id
      }
    }
  }
}

output "north_virginia" {
  description = "Resources created in North Virginia."
  value = {
    transit_gateway = aws_ec2_transit_gateway.nvirginia_tgw.id
    transit_gateway_route_tables = {
      prod    = aws_ec2_transit_gateway_route_table.prod_tgw_rt.id
      nonprod = aws_ec2_transit_gateway_route_table.nonprod_tgw_rt.id
    }
    vpcs = { for k, v in module.nvirginia_vpcs : k => v.vpc_id }
  }
}

output "ireland" {
  description = "Resources created in Ireland."
  value = {
    transit_gateway = aws_ec2_transit_gateway.ireland_tgw.id
    transit_gateway_route_tables = {
      prod    = aws_ec2_transit_gateway_route_table.prod_tgw_rt_ireland.id
      nonprod = aws_ec2_transit_gateway_route_table.nonprod_tgw_rt_ireland.id
    }
    vpcs = { for k, v in module.ireland_vpcs : k => v.vpc_id }
  }
}