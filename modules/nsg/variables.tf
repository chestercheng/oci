variable "compartment_ocid" {
  type        = string
  description = "The default compartment OCID to use for resources (unless otherwise specified)."
}

variable "vcn_ocid" {
  type        = string
  description = "The VCN ID where the Security List(s) should be created."
}

variable "nsg_display_name" {
  type        = string
  description = "Name of Network Security Group."
}

variable "freeform_tags" {
  type        = map(string)
  description = "The different freeform tags that are applied to each object by default."
  default     = {}
}

variable ingress_rules {
  description = "Any NSG ingress rules that should be added."
  default     = []
}

variable egress_rules {
  description = "Any NSG egress rules that should be added."
  default     = []
}
