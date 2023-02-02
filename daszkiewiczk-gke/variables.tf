variable "gcp_credentials" {
  type = string
  description = "service account credentials for GCP"
}

variable "gcp_project_name" {
  type = string
  description = "GCP project name"
}

variable "gcp_region" {
  type = string
  description = "GCP region"
}

variable "gcp_zoness" {
  type = list(string)
  description = "List of zones for GKE cluster"
  default = [ "europe-central2-a" ]
}


variable "gcp_network" {
    type = string
    description = "GCP VPC name"
  
}

variable "gcp_subnetwork" {
    type = string
    description = "GCP VPC subnetwork name"
}


variable "gke_cluster_name" {
  type = string
  description = "GKE Cluster name"
}

variable "gke_regional" {
  type = bool
  description = "Wheter to use regional cluster mode for GKE (expensive $$$$$$$$$$$$$$)"
}

variable "gke_node_pool_name" {
  type = string
  description = "GKE Node pool name"
}

variable "gke_use_spot_vms" {
    type = bool
  description = "Where to use spot VMs, which are less reliable but have better prcing"
}

variable "gke_use_preemtible_vms" {
    type = bool
  description = "Where to use preemtible VMs, which shutdown after 24hrs but have better prcing"
}

variable "gke_service_account_name" {
  type = string
  description = "cluster sa name"
}

variable "gke_machine_type" {
    type = string
    description = "size of node VMs"
  
}