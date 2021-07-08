variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created."
}

variable "vcn_display_name" {
  description = "Name of Virtual Cloud Network."
}

variable "vcn_cidr" {
  description = "A VCN covers a single, contiguous IPv4 CIDR block of your choice."
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet."
  default     = null
}

variable "subnets" {
  description = "Any subnet that should be added."
  default     = {}
}
