# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# --- root/cwan.tf ---

data "aws_networkmanager_core_network_policy_document" "policy" {
  core_network_configuration {
    vpn_ecmp_support = true
    asn_ranges       = ["64512-64520"]

    edge_locations {
      location = "us-east-1"
    }

    edge_locations {
      location = "eu-west-1"
    }
  }

  segments {
    name                          = "Prod"
    description                   = "Production segment."
    edge_locations                = ["us-east-1", "eu-west-1"]
    require_attachment_acceptance = false
  }

  segments {
    name                          = "NonProd"
    description                   = "Non-Production segment."
    edge_locations                = ["us-east-1", "eu-west-1"]
    require_attachment_acceptance = false
  }

  attachment_policies {
    rule_number     = 100
    condition_logic = "or"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "env"
      value    = "prod"
    }
    action {
      association_method = "constant"
      segment            = "Prod"
    }
  }

  attachment_policies {
    rule_number     = 200
    condition_logic = "or"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "env"
      value    = "nonprod"
    }
    action {
      association_method = "constant"
      segment            = "NonProd"
    }
  }
}
