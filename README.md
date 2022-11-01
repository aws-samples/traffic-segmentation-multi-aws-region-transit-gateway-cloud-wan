<!-- BEGIN_TF_DOCS -->
## Achieving traffic segmentation in multi-AWS Region environments using AWS Transit Gateway and AWS Cloud WAN

This repository shows a Terraform example on how to extend Transit Gateway route tables to AWS Cloud WAN segments, with the end goal of achieving traffic segmentation between routing domains in different AWS Regions when using AWS Transit Gateway.

![Architecture](./image/architectures.png)

This example builds the following resources (same in both AWS Regions indicated above):

* AWS Transit Gateway, with 2 Route Tables (*prod* and *nonprod*)
* 4 Spoke VPCs - 2 for *prod* and 2 for *nonprod* routing domain. The definition of the VPCs can be found in the *variables.tf* file.
* Cloud WAN resources - Global Network and Core Network. The policy can be found in the *cwan.tf* file.
* Transit Gateway policy table - and association to the peering connection.
* Cloud WAN - Transit Gateway peering connection.
* Transit Gateway route table attachment - *prod* and *nonprod*.

## Prerequisites
* An AWS account with an IAM user with the appropriate permissions
* Terraform installed

## Code Principles:
* Writing DRY (Do No Repeat Yourself) code using a modular design pattern

## Deployment and cleanup
* Clone the repository.
* Check the *variables.tf* file.
* Use `terraform apply` to create all the resources listed above.
* Remember to clean up after your work is complete. You can do that by doing `terraform destroy`. Note that this command will delete all the resources previously created by Terraform.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.28.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.37.0 |
| <a name="provider_aws.awsireland"></a> [aws.awsireland](#provider\_aws.awsireland) | 4.37.0 |
| <a name="provider_aws.awsnvirginia"></a> [aws.awsnvirginia](#provider\_aws.awsnvirginia) | 4.37.0 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | 0.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ireland_vpcs"></a> [ireland\_vpcs](#module\_ireland\_vpcs) | ./modules/vpc | n/a |
| <a name="module_nvirginia_vpcs"></a> [nvirginia\_vpcs](#module\_nvirginia\_vpcs) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.ireland_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway.nvirginia_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_policy_table.ireland_tgw_policy_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table) | resource |
| [aws_ec2_transit_gateway_policy_table.nvirginia_tgw_policy_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table) | resource |
| [aws_ec2_transit_gateway_policy_table_association.ireland_tgw_policy_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table_association) | resource |
| [aws_ec2_transit_gateway_policy_table_association.nvirginia_tgw_policy_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table_association) | resource |
| [aws_ec2_transit_gateway_route_table.nonprod_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.nonprod_tgw_rt_ireland](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.prod_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.prod_tgw_rt_ireland](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_networkmanager_transit_gateway_peering.cwan_ireland_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_peering) | resource |
| [aws_networkmanager_transit_gateway_peering.cwan_nvirginia_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_peering) | resource |
| [aws_networkmanager_transit_gateway_route_table_attachment.ireland_cwan_tgw_rt_attachment_nonprod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_route_table_attachment) | resource |
| [aws_networkmanager_transit_gateway_route_table_attachment.ireland_cwan_tgw_rt_attachment_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_route_table_attachment) | resource |
| [aws_networkmanager_transit_gateway_route_table_attachment.nvirginia_cwan_tgw_rt_attachment_nonprod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_route_table_attachment) | resource |
| [aws_networkmanager_transit_gateway_route_table_attachment.nvirginia_cwan_tgw_rt_attachment_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_route_table_attachment) | resource |
| [awscc_networkmanager_core_network.core_network](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/networkmanager_core_network) | resource |
| [awscc_networkmanager_global_network.global_network](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/networkmanager_global_network) | resource |
| [aws_networkmanager_core_network_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/networkmanager_core_network_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | AWS regions. | `map(string)` | <pre>{<br>  "ireland": "eu-west-1",<br>  "north_virginia": "us-east-1"<br>}</pre> | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Project Identifier. | `string` | `"traffic-segmentation-tgw-cwan"` | no |
| <a name="input_ireland_spoke_vpcs"></a> [ireland\_spoke\_vpcs](#input\_ireland\_spoke\_vpcs) | Information about the VPCs to create in eu-west-1. | `any` | <pre>{<br>  "non-prod-1": {<br>    "cidr_block": "10.1.2.0/24",<br>    "number_azs": 2,<br>    "type": "nonprod"<br>  },<br>  "non-prod-2": {<br>    "cidr_block": "10.1.3.0/24",<br>    "number_azs": 2,<br>    "type": "nonprod"<br>  },<br>  "prod-1": {<br>    "cidr_block": "10.1.0.0/24",<br>    "number_azs": 2,<br>    "type": "prod"<br>  },<br>  "prod-2": {<br>    "cidr_block": "10.1.1.0/24",<br>    "number_azs": 2,<br>    "type": "prod"<br>  }<br>}</pre> | no |
| <a name="input_nvirginia_spoke_vpcs"></a> [nvirginia\_spoke\_vpcs](#input\_nvirginia\_spoke\_vpcs) | Information about the VPCs to create in us-east-1. | `any` | <pre>{<br>  "non-prod-1": {<br>    "cidr_block": "10.0.2.0/24",<br>    "number_azs": 2,<br>    "type": "nonprod"<br>  },<br>  "non-prod-2": {<br>    "cidr_block": "10.0.3.0/24",<br>    "number_azs": 2,<br>    "type": "nonprod"<br>  },<br>  "prod": {<br>    "cidr_block": "10.0.0.0/24",<br>    "number_azs": 2,<br>    "type": "prod"<br>  },<br>  "prod-2": {<br>    "cidr_block": "10.0.1.0/24",<br>    "number_azs": 2,<br>    "type": "prod"<br>  }<br>}</pre> | no |
| <a name="input_transit_gateway_asn"></a> [transit\_gateway\_asn](#input\_transit\_gateway\_asn) | Amazon Side ASNs to apply in the Transit Gateways. | `map(string)` | <pre>{<br>  "ireland": 65051,<br>  "north_virginia": 65050<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_wan"></a> [cloud\_wan](#output\_cloud\_wan) | Cloud WAN resources. |
| <a name="output_ireland"></a> [ireland](#output\_ireland) | Resources created in Ireland. |
| <a name="output_north_virginia"></a> [north\_virginia](#output\_north\_virginia) | Resources created in North Virginia. |
<!-- END_TF_DOCS -->