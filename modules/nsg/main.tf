######################
# Network Security Group
######################
resource "oci_core_network_security_group" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = var.nsg_display_name
  freeform_tags  = var.freeform_tags
}

######################
# Network Security Group Rules
######################
locals {
  # INGRESS rules
  ingress_tcp_rules = flatten([for i in var.ingress_rules :
    {
      direction              = "INGRESS"
      protocol               = i.protocol
      description            = lookup(i, "description", null)
      stateless              = lookup(i, "stateless", false)
      source                 = lookup(i, "source", null)
      source_type            = lookup(i, "source_type", null)
      source_port_range      = lookup(i, "source_port_range", null)
      destination            = lookup(i, "destination", null)
      destination_type       = lookup(i, "destination_type", null)
      destination_port_range = lookup(i, "destination_port_range", null)
    } if i.protocol == "6"
  ])
  ingress_udp_rules = flatten([for i in var.ingress_rules :
    {
      direction              = "INGRESS"
      protocol               = i.protocol
      description            = lookup(i, "description", null)
      stateless              = lookup(i, "stateless", false)
      source                 = lookup(i, "source", null)
      source_type            = lookup(i, "source_type", null)
      source_port_range      = lookup(i, "source_port_range", null)
      destination            = lookup(i, "destination", null)
      destination_type       = lookup(i, "destination_type", null)
      destination_port_range = lookup(i, "destination_port_range", null)
    } if i.protocol == "17"
  ])
  ingress_icmp_rules = flatten([for i in var.ingress_rules :
    {
      direction        = "INGRESS"
      protocol         = i.protocol
      description      = lookup(i, "description", null)
      stateless        = lookup(i, "stateless", false)
      source           = lookup(i, "source", null)
      source_type      = lookup(i, "source_type", null)
      destination      = lookup(i, "destination", null)
      destination_type = lookup(i, "destination_type", null)
      icmp_code        = lookup(i, "icmp_code", null)
      icmp_type        = lookup(i, "icmp_type", null)
    } if i.protocol == "1" || i.protocol == "58"
  ])

  # EGRESS rules
  egress_tcp_rules = flatten([for i in var.egress_rules :
    {
      direction              = "EGRESS"
      protocol               = i.protocol
      description            = lookup(i, "description", null)
      stateless              = lookup(i, "stateless", false)
      source                 = lookup(i, "source", null)
      source_type            = lookup(i, "source_type", null)
      source_port_range      = lookup(i, "source_port_range", null)
      destination            = lookup(i, "destination", null)
      destination_type       = lookup(i, "destination_type", null)
      destination_port_range = lookup(i, "destination_port_range", null)
    } if i.protocol == "6"
  ])
  egress_udp_rules = flatten([for i in var.egress_rules :
    {
      direction              = "EGRESS"
      protocol               = i.protocol
      description            = lookup(i, "description", null)
      stateless              = lookup(i, "stateless", false)
      source                 = lookup(i, "source", null)
      source_type            = lookup(i, "source_type", null)
      source_port_range      = lookup(i, "source_port_range", null)
      destination            = lookup(i, "destination", null)
      destination_type       = lookup(i, "destination_type", null)
      destination_port_range = lookup(i, "destination_port_range", null)
    } if i.protocol == "17"
  ])
  egress_icmp_rules = flatten([for i in var.egress_rules :
    {
      direction        = "EGRESS"
      protocol         = i.protocol
      description      = lookup(i, "description", null)
      stateless        = lookup(i, "stateless", false)
      source           = lookup(i, "source", null)
      source_type      = lookup(i, "source_type", null)
      destination      = lookup(i, "destination", null)
      destination_type = lookup(i, "destination_type", null)
      icmp_code        = lookup(i, "icmp_code", null)
      icmp_type        = lookup(i, "icmp_type", null)
    } if i.protocol == "1" || i.protocol == "58"
  ])

  # Security rules - merged
  tcp_rules  = concat(local.ingress_tcp_rules, local.egress_tcp_rules)
  udp_rules  = concat(local.ingress_udp_rules, local.egress_udp_rules)
  icmp_rules = concat(local.ingress_icmp_rules, local.egress_icmp_rules)
}
# resource definitions
resource "oci_core_network_security_group_security_rule" "tcp_rules" {
  depends_on                = [oci_core_network_security_group.this]
  network_security_group_id = oci_core_network_security_group.this.id

  count            = length(local.tcp_rules)
  direction        = local.tcp_rules[count.index].direction
  protocol         = local.tcp_rules[count.index].protocol
  description      = local.tcp_rules[count.index].description
  stateless        = local.tcp_rules[count.index].stateless
  source           = local.tcp_rules[count.index].source
  source_type      = local.tcp_rules[count.index].source_type
  destination      = local.tcp_rules[count.index].destination
  destination_type = local.tcp_rules[count.index].destination_type

  tcp_options {
    dynamic "source_port_range" {
      for_each = local.tcp_rules[count.index].source_port_range != null ? [1] : []
      content {
        min = local.tcp_rules[count.index].source_port_range.min
        max = local.tcp_rules[count.index].source_port_range.max
      }
    }

    dynamic "destination_port_range" {
      for_each = local.tcp_rules[count.index].destination_port_range != null ? [1] : []
      content {
        min = local.tcp_rules[count.index].destination_port_range.min
        max = local.tcp_rules[count.index].destination_port_range.max
      }
    }
  }
}

resource "oci_core_network_security_group_security_rule" "udp_rules" {
  depends_on                = [oci_core_network_security_group.this]
  network_security_group_id = oci_core_network_security_group.this.id

  count            = length(local.udp_rules)
  direction        = local.udp_rules[count.index].direction
  protocol         = local.udp_rules[count.index].protocol
  description      = local.udp_rules[count.index].description
  stateless        = local.udp_rules[count.index].stateless
  source           = local.udp_rules[count.index].source
  source_type      = local.udp_rules[count.index].source_type
  destination      = local.udp_rules[count.index].destination
  destination_type = local.udp_rules[count.index].destination_type

  udp_options {
    dynamic "source_port_range" {
      for_each = local.udp_rules[count.index].source_port_range != null ? [1] : []
      content {
        min = local.udp_rules[count.index].source_port_range.min
        max = local.udp_rules[count.index].source_port_range.max
      }
    }

    dynamic "destination_port_range" {
      for_each = local.udp_rules[count.index].destination_port_range != null ? [1] : []
      content {
        min = local.udp_rules[count.index].destination_port_range.min
        max = local.udp_rules[count.index].destination_port_range.max
      }
    }
  }
}

resource "oci_core_network_security_group_security_rule" "icmp_rules" {
  depends_on                = [oci_core_network_security_group.this]
  network_security_group_id = oci_core_network_security_group.this.id

  count            = length(local.icmp_rules)
  direction        = local.icmp_rules[count.index].direction
  protocol         = local.icmp_rules[count.index].protocol
  description      = local.icmp_rules[count.index].description
  stateless        = local.icmp_rules[count.index].stateless
  source           = local.icmp_rules[count.index].source
  source_type      = local.icmp_rules[count.index].source_type
  destination      = local.icmp_rules[count.index].destination
  destination_type = local.icmp_rules[count.index].destination_type

  dynamic "icmp_options" {
    for_each = local.icmp_rules[count.index].icmp_code != null || local.icmp_rules[count.index].icmp_type != null ? [1] : []
    content {
      code = local.icmp_rules[count.index].icmp_code
      type = local.icmp_rules[count.index].icmp_type
    }
  }
}
