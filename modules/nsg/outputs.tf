output "nsg_id" {
  description = "The Network Security Group(s) (NSGs) created/managed."
  value       = oci_core_network_security_group.this.id
}

output "nsg_rules" {
  description = "The NSG rules created/managed."
  value = flatten(
    concat(
      oci_core_network_security_group_security_rule.tcp_rules,
      oci_core_network_security_group_security_rule.udp_rules,
      oci_core_network_security_group_security_rule.icmp_rules,
    )
  )
}
