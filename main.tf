resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_customer_gateway" "this" {
  for_each   = var.connections
  ip_address = each.value.gateway_ip_address
  type       = each.value.type
  bgp_asn    = each.value.bgp_asn
  tags = {
    Name = each.key
  }
}

resource "aws_cloudwatch_log_group" "tunnel1" {
  for_each          = var.connections
  name              = "${var.name}/${each.key}/tunnel1"
  retention_in_days = each.value.cloudwatch_retention_days
}

resource "aws_cloudwatch_log_group" "tunnel2" {
  for_each          = var.connections
  name              = "${var.name}/${each.key}/tunnel2"
  retention_in_days = each.value.cloudwatch_retention_days
}

resource "aws_vpn_connection" "this" {
  for_each                             = var.connections
  vpn_gateway_id                       = aws_vpn_gateway.this.id
  customer_gateway_id                  = aws_customer_gateway.this[each.key].id
  type                                 = each.value.type
  static_routes_only                   = each.value.static_routes_only
  tunnel1_startup_action               = each.value.tunnel1_startup_action
  tunnel1_preshared_key                = each.value.tunnel1_preshared_key
  tunnel1_ike_versions                 = each.value.tunnel1_ike_versions
  tunnel1_dpd_timeout_action           = each.value.tunnel1_dpd_timeout_action
  tunnel1_phase1_dh_group_numbers      = each.value.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = each.value.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = each.value.tunnel1_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = each.value.tunnel1_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers      = each.value.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = each.value.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = each.value.tunnel1_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = each.value.tunnel1_phase2_lifetime_seconds

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.tunnel1[each.key].arn
      log_output_format = each.value.cloudwatch_log_format
    }
  }

  tunnel2_startup_action               = each.value.tunnel1_startup_action
  tunnel2_preshared_key                = each.value.tunnel1_preshared_key
  tunnel2_ike_versions                 = each.value.tunnel1_ike_versions
  tunnel2_dpd_timeout_action           = each.value.tunnel1_dpd_timeout_action
  tunnel2_phase1_dh_group_numbers      = each.value.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = each.value.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = each.value.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_lifetime_seconds      = each.value.tunnel1_phase1_lifetime_seconds
  tunnel2_phase2_dh_group_numbers      = each.value.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = each.value.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = each.value.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_lifetime_seconds      = each.value.tunnel1_phase2_lifetime_seconds

  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.tunnel2[each.key].arn
      log_output_format = each.value.cloudwatch_log_format
    }
  }

  tags = {
    Name = each.key
  }
}

resource "aws_vpn_connection_route" "this" {
  for_each = { for route in flatten([
    for k, v in var.connections : [
      for b in v.static_routes : {
        key                    = "${k}-${b}"
        destination_cidr_block = b
        vpn_connection_id      = aws_vpn_connection.this[k].id
      }
    ]
  ]) : route.key => route }
  destination_cidr_block = each.value.destination_cidr_block
  vpn_connection_id      = each.value.vpn_connection_id
}