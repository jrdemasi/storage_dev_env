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

resource "vultr_vpc" "devstack_vpc" {
    description = "devstack vpc"
    region = "ewr"
}

resource "vultr_firewall_group" "devstack_internal" {
    description = "Firewall group for devstack internal nodes"
}

resource "vultr_firewall_rule" "allow_all_devstack" {
    firewall_group_id = vultr_firewall_group.devstack_internal.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "${vultr_vpc.devstack_vpc.v4_subnet}"
    subnet_size = "${vultr_vpc.devstack_vpc.v4_subnet_mask}"
    notes = "Allow all within devstack vpc"
    port = "1:65535"
}

resource "vultr_instance" "zfs00_instance" {
    plan = "vc2-1c-1gb"
    region = "ewr"
    os_id = 1743 # Ubuntu 22.04 LTS
    label = "zfs00"
    tags = ["devstack"]
    hostname = "zfs00.vultr.jthan.io"
    enable_ipv6 = true
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    vpc_ids = ["${vultr_vpc.devstack_vpc.id}"]
    firewall_group_id = vultr_firewall_group.devstack_internal.id
    user_data = "${file("files/zfs-cloud-init.sh")}"
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
    tags = ["devstack"]
    hostname = "zfs01.vultr.jthan.io"
    enable_ipv6 = true
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    vpc_ids = ["${vultr_vpc.devstack_vpc.id}"]
    firewall_group_id = vultr_firewall_group.devstack_internal.id
    user_data = "${file("files/zfs-cloud-init.sh")}"
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
