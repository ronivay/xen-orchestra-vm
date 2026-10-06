# Xen Orchestra VM image

This packer setup is used to build Xen Orchestra VM image to be used by xo-vm-import.sh script in https://github.com/ronivay/XenOrchestraInstallerUpdater

VM image is built on an existing XCP-ng host utilizing a packer plugin: https://github.com/vatesfr/packer-plugin-xenserver

### Usage

Input required variables by creating a `./packer/secrets.auto.pkrvars.hcl` file which is automatically loaded by packer. Content should look as follows:

```
# XCP-ng host connection details
xcp_host      = "<ip/hostname>"
xcp_user      = "<username>"
xcp_password  = "<password>"
# Pool SR name to be used for ISO upload and VM disk
sr_name       = "<sr name>"
# Pool network name where VM is attached to
network_names = [
  "<network name>"
]
# Optional preseed.cfg URL to be used by debian autoinstallation. By default packer will expose contents from ./http/preseed.cfg, meaning XCP-ng host needs to be able to communicate with server running packer
preseed_url   = "<url>"
```

Install required packer plugins:

`packer init ./packer`

Run build:

`packer build ./packer`

Once build is complete, you'll have the compressed xva file in `./xo-ce-final/xo-ce.xva.gz`.

Automatically process the end result image:

Modify `./bin/process-template.sh` script to add optional steps to process the image in ways that you wish.

By default the VM's VIF (network interface) is deleted and needs to be recreated after importing the XVA. Deletion is done over SSH directly on XCP-ng host, requiring the user running packer to be able to access the host via passwordless SSH connection. This can be skipped by passing `-var "enable_vif_cleanup=false"` to packer build.
