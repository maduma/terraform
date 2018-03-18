provider "openstack" {
  user_name   = "facebook100000270138421"
  tenant_name = "facebook100000270138421"
  password    = "U4DVnzyKqieV0VoO"
  auth_url    = "http://8.43.86.2:5000/v2.0"
  region      = "RegionOne"
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
