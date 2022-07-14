# storage_dev_env

This repo contains terraform to deploy a gluster on ZFS environment in Vultr for development and testing purposes.  In the future, I would like to expand this to also support Linode, AWS, etc. The terraform also needs to be refactors to be more granular, reusable, so on. avahi-daemon is included to provide name resolution within the VPC regardless of the IPs that get assigned and to avoid using static hosts.  

## Design Considerations

This repo was designed to quickly turn up resources to test a stack that I frequently play with.  It utilizes Ubuntu for a few reasons - namely the fact that ZFS is included in the kernel, as well as the fact that at the time of creating this project I was polishing my Ubuntu chops.  Some choices were made to enable ease of access, such as adding the IP address wherever Terraform is executed to the firewall group for all of the nodes.  Additionally, ufw is disabled within Ubuntu so the firewall can be managed entirely via security groups or cloud firewall.  In the future, as the stack grows, a management node that serves as a bastion would be advisable.

## Setup
First ensure you have a Vultr API key defined as an environment variable or otherwise accessible to Terraform:
```
export TF_VAR_vultr_api_key="<your API key>"
```
