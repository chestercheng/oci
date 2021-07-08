variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created."
}

variable "vm_ad" {
  description = "The availability domain of the instance."
  default     = null
}

variable "vm_display_name" {
  description = "Name of Compute Instance."
}

variable "vm_shape" {
  description = "The shape of an instance."
  default     = "VM.Standard.E2.1.Micro"
}

variable "image_ocid" {
  description = "See: https://docs.oracle.com/en-us/iaas/images/"
}

variable "ssh_authorized_key" {
  description = "Provide public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
}

variable "subnet_ocid" {
  description = "The OCID of the subnet to create the VNIC in."
}

variable "network_security_groups" {
  description = "A list of the OCIDs of the network security groups (NSGs) to add the VNIC to."
  type        = list(string)
  default     = []
}
