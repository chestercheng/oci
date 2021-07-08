output "instance_id" {
  description = "ocid of created Instance."
  value       = oci_core_instance.this.id
}

output "vnic_id" {
  description = "ocid of first vnic."
  value       = data.oci_core_vnic_attachments.this.vnic_attachments.0.vnic_id
}

output "private_ip_id" {
  description = "ocid of private ip."
  value       = data.oci_core_private_ips.this.private_ips.0.id
}

output "private_ip_address" {
  description = "IP address of private ip."
  value       = data.oci_core_private_ips.this.private_ips.0.ip_address
}
