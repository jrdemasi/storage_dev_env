# storage_dev_env

This repo contains terraform to deploy a gluster on ZFS environment in Vultr for development and testing purposes.  In the future, I would like to expand this to also support Linode, AWS, etc. The terraform also needs to be refactored to be more granular, reusable, so on. 

## Design Considerations

* Quickly deploy a dev/testing environment for gluster-on-zfs
* Uses Ubuntu 22.04 because of ZFS being present in the kernel, plus I had to brush up on Ubuntu chops
* IP address of wherever Terraform is executed is added to firewall group for management node
* Management node also serves as client for gluster volume(s), this reduces complexity and cost
* avahi-daemon included for name resolution within VPC to simplify shelling around and use of gluster


## Setup
1. First ensure you have a Vultr API key defined as an environment variable or otherwise accessible to Terraform:
```
export TF_VAR_vultr_api_key="<your API key>"

```

2. After ensuring the API key environment variable is set, change into the appropriate module folder, and initialize terraform:
```
cd terraform/modules/vultr_zfs_node
terraform init
```

## Cleanup

1. Change into the terraform directory you deployed from and run terraform destroy:
```
cd terraform/modules/vultr_zfs_node
terraform destroy
```
2. When prompted, verify what is being removed, and type 'yes' at the prompt