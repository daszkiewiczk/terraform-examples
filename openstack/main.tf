terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

resource "openstack_compute_instance_v2" "webserver-a" {
  name              = var.webserver_name
  image_id          = var.openstack_webserver_image_id

  flavor_id         = var.openstack_webserver_flavor_id
  security_groups   = var.openstack_security_groups
  network {
                      name = var.openstack_network_name
  }
}