source "xenserver-iso" "xo-ce" {
  remote_host       = var.xcp_host
  remote_username   = var.xcp_user
  remote_password   = var.xcp_password
  ssh_username      = "root"
  ssh_password      = "debian"
  ssh_timeout       = "20m"
  skip_set_template = true
  # Only used when serving preseed locally
  http_directory   = "./http"
  output_directory = "./xo-ce-artifact"
  sr_name          = var.sr_name
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  vm_name          = local.build_id
  vm_description   = "xo-ce Debian 13"
  vcpus_max        = 2
  vcpus_atstartup  = 2
  vm_memory        = 4096
  disk_size        = 10240 # 10 GB in MB
  disk_name        = "xo-ce root"
  network_names    = var.network_names
  boot_command = [
    "<esc><wait>",
    "install ",
    "auto=true ",
    "priority=critical ",
    "preseed/url=${var.preseed_url != "" ? var.preseed_url : "http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg"} ",
    "hostname=xo-ce ",
    "domain=local ",
    "-- ",
    "<Enter>"
  ]
}

build {
  sources = ["source.xenserver-iso.xo-ce"]

  provisioner "ansible" {
    playbook_file = "./ansible/play.yml"
    roles_path    = "./ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_CONFIG=./ansible.cfg"
    ]
  }

  provisioner "shell-local" {
    inline = [
      <<-EOF
        if [ "${var.enable_vif_cleanup}" = "true" ]; then
            VM_UUID=$(ssh root@${var.xcp_host} "xe vm-list name-label=${local.build_id} params=uuid --minimal")
            VIF_UUID=$(ssh root@${var.xcp_host} "xe vif-list vm-uuid=$VM_UUID params=uuid --minimal")
            if [ -n "$VIF_UUID" ]; then
              ssh root@${var.xcp_host} "xe vif-unplug uuid=$VIF_UUID"
              ssh root@${var.xcp_host} "xe vif-destroy uuid=$VIF_UUID"
            fi
        fi
      EOF
    ]
  }

  post-processors {
    post-processor "compress" {
      output              = "./xo-ce-final/xo-ce.xva.gz"
      keep_input_artifact = false
    }
    # This is used to process the end result xo-ce.gz further if needed
    post-processor "shell-local" {
      inline = [
        "./bin/process-template.sh"
      ]
    }
  }
}
