provider "openstack" {
  user_name   = "facebook100000270138421"
  tenant_name = "facebook100000270138421"
  password    = "U4DVnzyKqieV0VoO"
  auth_url    = "http://8.43.86.2:5000/v2.0"
  region      = "RegionOne"
}

resource "openstack_compute_keypair_v2" "snsakala" {
  name       = "snsakala"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBlF377o8DpYop4x9kDhFJ4lpHnzDpOUtKtI4QI5OTmvWX3cld0ga2N2opQUCGJuUbRWaVyhLKOBobJ5yfUc3wP1l9F5IAylDH2EDRKGiohA2vbK37k7Tv6kiQs/IfZ2DL11uYqHjfc72efak88NYzYi3Z3Jj+65EfnDFmTMB+Yow== Stephane Nsakala"
}

resource "openstack_networking_router_v2" "router" {
  name = "router"
}
/*
resource "openstack_compute_instance_v2" "rproxy" {
  name        = "rproxy"
  image_name  = "Ubuntu16.04"
  flavor_name = "m1.small"
  key_pair    = "snsakala"
}
*/
