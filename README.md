# storage_dev_env

This repo contains terraform to deploy a gluster on ZFS environment in Vultr for development and testing purposes.  In the future, I would like to expand this to also support Linode, AWS, etc. The terraform also needs to be refactors to be more granular, reusable, so on.  

## Setup
First ensure you have a Vultr API key defined as an environment variable or otherwise accessible to Terraform
```
export TF_VAR_vultr_api_key="<your API key>"
```

