
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.gcp_project_name
  name                       = var.gke_cluster_name
  region                     = var.gcp_region

  regional                   = var.gke_regional

  zones                      = var.gcp_zoness
  network                    = var.gcp_network
  subnetwork                 = var.gcp_subnetwork
  /*
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  */

  ip_range_pods              = ""
  ip_range_services          = ""

  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false

  node_pools = [
    {
      name                      = var.gke_node_pool_name
      machine_type              = var.gke_machine_type
      #node_locations            = "us-central1-b,us-central1-c"
      min_count                 = 1
      max_count                 = 3
      local_ssd_count           = 0
      spot                      = var.gke_use_spot_vms
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      #service_account           = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      service_account           = var.gke_service_account_name
      preemptible               = var.gke_use_preemtible_vms
      initial_node_count        = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}