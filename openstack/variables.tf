variable "openstack_auth_url" {
  type = string
}

variable "openstack_user_name" {
  type = string
}

variable "openstack_tenant_name" {
    type = string
}

variable "openstack_password" {
  type = string
}

variable "openstack_region" {
  type = string
}

variable "openstack_webserver_flavor_id" {
  type = string
}

variable "openstack_network_name" {
  type = string
}

variable "openstack_webserver_image_id" {
  type = string
}

variable "openstack_security_groups" {
  type = list(string)
}

#variable "openstack_domain_name" {
#  type = string
#}

variable "webserver_name" {
  type = string
}
