terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.11.3"
    }
  }
}
# Configure the Vultr Provider
provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 700
  retry_limit = 3
}

resource "vultr_vpc" "storage_dev_env_vpc" {
    description = "storage_dev_env vpc"
    region = "ewr"
}

# Internal storage node firewall
resource "vultr_firewall_group" "storage_dev_env_internal" {
    description = "Firewall group for storage_dev_env internal nodes"
}

resource "vultr_firewall_rule" "allow_all_storage_dev_env_internal" {
    firewall_group_id = vultr_firewall_group.storage_dev_env_internal.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "${vultr_vpc.storage_dev_env_vpc.v4_subnet}"
    subnet_size = "${vultr_vpc.storage_dev_env_vpc.v4_subnet_mask}"
    notes = "Allow all within storage_dev_env vpc"
    port = "1:65535"
}

# Management node firewall, which includes public SSH access 
resource "vultr_firewall_group" "storage_dev_env_mgmt" {
    description = "Firewall group for storage_dev_env management node(s)"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "vultr_firewall_rule" "allow_ssh_myip" {
    firewall_group_id = vultr_firewall_group.storage_dev_env_mgmt.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "${chomp(data.http.myip.body)}"
    subnet_size = "32"
    notes = "Allow SSH from terraform execution location"
    port = "22"
}

resource "vultr_firewall_rule" "allow_all_storage_dev_env_mgmt" {
    firewall_group_id = vultr_firewall_group.storage_dev_env_mgmt.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "${vultr_vpc.storage_dev_env_vpc.v4_subnet}"
    subnet_size = "${vultr_vpc.storage_dev_env_vpc.v4_subnet_mask}"
    notes = "Allow all within storage_dev_env vpc"
    port = "1:65535"
}


resource "vultr_instance" "zfs00_instance" {
    plan = "vc2-1c-1gb"
    region = "ewr"
    os_id = 1743 # Ubuntu 22.04 LTS
    label = "zfs00"
    tags = ["storage_dev_env"]
    hostname = "zfs00.vultr.jthan.io"
    enable_ipv6 = true
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    vpc_ids = ["${vultr_vpc.storage_dev_env_vpc.id}"]
    firewall_group_id = vultr_firewall_group.storage_dev_env_internal.id
    user_data = "${file("files/storage-cloud-init.sh")}"
}

resource "vultr_block_storage" "zfs00_vol0" {
    size_gb = 40
    region = "ewr"
    block_type = "storage_opt"
    live   = true
    attached_to_instance = vultr_instance.zfs00_instance.id
}

resource "vultr_block_storage" "zfs00_vol1" {
    size_gb = 40
    region = "ewr"
    block_type = "storage_opt"
    live   = true
    attached_to_instance = vultr_instance.zfs00_instance.id
}

resource "vultr_instance" "zfs01_instance" {
    plan = "vc2-1c-1gb"
    region = "ewr"
    os_id = 1743 # Ubuntu 22.04 LTS
    label = "zfs01"
    tags = ["storage_dev_env"]
    hostname = "zfs01.vultr.jthan.io"
    enable_ipv6 = true
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    vpc_ids = ["${vultr_vpc.storage_dev_env_vpc.id}"]
    firewall_group_id = vultr_firewall_group.storage_dev_env_internal.id
    user_data = "${file("files/storage-cloud-init.sh")}"
}


resource "vultr_block_storage" "zfs01_vol0" {
    size_gb = 40
    region = "ewr"
    block_type = "storage_opt"
    live   = true
    attached_to_instance = vultr_instance.zfs01_instance.id
}

resource "vultr_block_storage" "zfs01_vol1" {
    size_gb = 40
    region = "ewr"
    block_type = "storage_opt"
    live   = true
    attached_to_instance = vultr_instance.zfs01_instance.id
}

resource "vultr_instance" "mgmt00_instance" {
    plan = "vc2-1c-1gb"
    region = "ewr"
    os_id = 1743 # Ubuntu 22.04 LTS
    label = "mgmt00"
    tags = ["storage_dev_env"]
    hostname = "mgmt00.vultr.jthan.io"
    enable_ipv6 = true
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    vpc_ids = ["${vultr_vpc.storage_dev_env_vpc.id}"]
    firewall_group_id = vultr_firewall_group.storage_dev_env_mgmt.id
    user_data = "${file("files/mgmt-cloud-init.sh")}"
}
