terraform {
  backend "remote" {
    organization = "chestercheng"

    workspaces {
      name = "oci"
    }
  }

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.28.0"
    }
  }
}

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  region               = var.region
  private_key          = var.private_key
  private_key_password = var.private_key_password
}

resource "oci_identity_compartment" "kauai" {
  name        = "kauai"
  description = "kauai"
}

module "networking" {
  source           = "./modules/networking"
  compartment_ocid = oci_identity_compartment.kauai.id
  vcn_display_name = "vcn"
  vcn_cidr         = "10.1.0.0/16"

  subnets = {
    "subnet" = { cidr_block = "10.1.1.0/24" },
  }
}

module "nsg" {
  source           = "./modules/nsg"
  vcn_ocid         = module.networking.vcn_id
  compartment_ocid = oci_identity_compartment.kauai.id
  nsg_display_name = "nsg"

  ingress_rules = [
    {
      description = "ssh"
      protocol    = "6"
      source      = "0.0.0.0/0"
      destination_port_range = {
        min = "22"
        max = "22"
      }
    },
    {
      description = "ssh tunnel"
      protocol    = "6"
      source      = "0.0.0.0/0"
      destination_port_range = {
        min = "7864"
        max = "7864"
      }
    },
  ]
}

module "vm" {
  depends_on              = [module.networking]
  source                  = "./modules/instance"
  compartment_ocid        = oci_identity_compartment.kauai.id
  vm_display_name         = "vm"
  vm_shape                = "VM.Standard.E2.1.Micro"
  image_ocid              = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaahklxhfmawzo4adpq74egsnjirfh5ttbtkwoael6bgkkivmqmv6ja"
  subnet_ocid             = module.networking.subnets.0.id
  network_security_groups = [module.nsg.nsg_id]
  ssh_authorized_key      = var.ssh_authorized_key
}

resource "oci_core_public_ip" "vm_public_ip" {
  compartment_id = oci_identity_compartment.kauai.id
  private_ip_id  = module.vm.private_ip_id
  display_name   = "vm-public-ip"
  lifetime       = "RESERVED"
}

output "vm_private_ip" {
  value = module.vm.private_ip_address
}

output "vm_public_ip" {
  value = oci_core_public_ip.vm_public_ip.ip_address
}
