variable "password" {}
variable "bootstrap" {
  default = "https://raw.githubusercontent.com/maduma/install_docker_ubuntu/master/install-docker.sh"
}

provider "openstack" {
  user_name   = "facebook100000270138421"
  tenant_name = "facebook100000270138421"
  password    = "${var.password}"
  auth_url    = "http://8.43.86.2:5000/v2.0"
  region      = "RegionOne"
}

resource "openstack_compute_keypair_v2" "snsakala" {
  name       = "snsakala"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBlF377o8DpYop4x9kDhFJ4lpHnzDpOUtKtI4QI5OTmvWX3cld0ga2N2opQUCGJuUbRWaVyhLKOBobJ5yfUc3wP1l9F5IAylDH2EDRKGiohA2vbK37k7Tv6kiQs/IfZ2DL11uYqHjfc72efak88NYzYi3Z3Jj+65EfnDFmTMB+Yow== Stephane Nsakala"
}

resource "openstack_networking_secgroup_v2" "admin" {
  name        = "admin"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.admin.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.admin.id}"
}

resource "openstack_networking_network_v2" "internal" {
  name           = "internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "admin" {
  name            = "admin"
  network_id      = "${openstack_networking_network_v2.internal.id}"
  cidr            = "10.10.10.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_router_v2" "router" {
  name = "router"
  external_network_id = "1fd0a21e-e700-46ae-9f05-0b3164daafcc"
}

resource "openstack_networking_router_interface_v2" "router_internal" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.admin.id}"
}


resource "openstack_compute_instance_v2" "docker" {
  count           = 2
  name            = "docker${count.index}"
  image_name      = "Ubuntu16.04"
  flavor_name     = "m1.small"
  key_pair        = "snsakala"
  security_groups = ["default", "admin"]
  user_data       = "#!/bin/bash -x\ncurl -s ${var.bootstrap} | bash -x\n"

  network {
    name = "internal"
  }
}

resource "openstack_compute_instance_v2" "proxy" {
  name            = "proxy"
  image_name      = "Ubuntu16.04"
  flavor_name     = "m1.small"
  key_pair        = "snsakala"
  security_groups = ["default", "admin"]
  user_data       = "#!/bin/bash -x\ncurl -s ${var.bootstrap} | bash -x\n"

  network {
    name = "internal"
  }
}

resource "openstack_networking_floatingip_v2" "publicip" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "proxyip" {
  floating_ip = "${openstack_networking_floatingip_v2.publicip.address}"
  instance_id = "${openstack_compute_instance_v2.proxy.id}"
}

output "publicip" {
  value = "${openstack_networking_floatingip_v2.publicip.address}"
}
