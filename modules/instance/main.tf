data "oci_identity_availability_domains" "this" {
  compartment_id = var.compartment_ocid
}

resource "oci_core_instance" "this" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.vm_ad != null ? var.vm_ad : data.oci_identity_availability_domains.this.availability_domains.0.name
  shape               = var.vm_shape
  display_name        = var.vm_display_name

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    display_name     = "${var.vm_display_name}-vnic"
    assign_public_ip = false
    subnet_id        = var.subnet_ocid
    nsg_ids          = var.network_security_groups
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_key
  }
}

# Gets a list of VNIC attachments on the instance
data "oci_core_vnic_attachments" "this" {
  compartment_id      = var.compartment_ocid
  instance_id         = oci_core_instance.this.id
  availability_domain = oci_core_instance.this.availability_domain
}

# Gets the OCID of the first VNIC
data "oci_core_vnic" "this" {
  vnic_id = data.oci_core_vnic_attachments.this.vnic_attachments.0.vnic_id
}

# Gets a list of private IPs on the first VNIC
data "oci_core_private_ips" "this" {
  vnic_id = data.oci_core_vnic.this.id
}
