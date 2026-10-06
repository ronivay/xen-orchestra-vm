# dynamic & secret values are loaded from secrets.auto.pkrvars.hcl

variable "vm_prefix" {
  type    = string
  default = "xo-ce"
}

locals {
  build_id = "${var.vm_prefix}-${legacy_isotime("20060102-150405")}"
}

variable "enable_vif_cleanup" {
  type    = bool
  default = true
}

variable "xcp_host" {
  type        = string
  description = "XCP-ng Pool Master IP or FQDN"
  default     = "127.0.0.1"
}

variable "xcp_user" {
  type        = string
  description = "XCP-ng Username"
  default     = "root"
}

variable "xcp_password" {
  type        = string
  sensitive   = true
  description = "XCP-ng Root Password"
  default     = "password"
}

variable "sr_name" {
  type        = string
  description = "Target Storage Repository"
  default     = "default"
}

variable "network_names" {
  type        = list(string)
  description = "List of network names to attach the VM to"
  default     = ["Pool-wide network associated with eth0"]
}

variable "iso_url" {
  type        = string
  description = "ISO URL for the OS installation"
  default     = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.7.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type        = string
  description = "Checksum file URL for the ISO"
  default     = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
}

variable "preseed_url" {
  type        = string
  description = "Custom preseed URL. Leave empty to use Packer's built-in HTTP server."
  default     = ""
}
