resource "oci_core_vcn" "this" {
  dns_label      = var.vcn_dns_label
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_security_list_id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.vcn_cidr
  }
}

resource "oci_core_subnet" "this" {
  depends_on          = [oci_core_vcn.this]
  for_each            = var.subnets
  display_name        = each.key
  cidr_block          = each.value.cidr_block
  compartment_id      = lookup(each.value, "compartment_id", var.compartment_ocid)
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_vcn.this.default_route_table_id
  availability_domain = lookup(each.value, "availability_domain", null)
}

data "oci_core_subnets" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
}
