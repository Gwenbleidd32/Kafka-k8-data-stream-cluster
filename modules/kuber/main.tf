/*KUBERNETES-INFASTRUCTURE*/

#Kubernetes-Provider
/*
provider "kubernetes" {
  config_path = "~/.kube/config"
}
*/
#>>>

#Service-Layer-Controls
resource "google_container_cluster" "fleet-1" {
  name     = var.kube.fleet_name
  location = var.kube.subnet_region

  networking_mode = "VPC_NATIVE" #Specifies the default networking mode for the cluster
    network       = var.kube.net_name
    subnetwork    = var.kube.subnet_name

  remove_default_node_pool = true
    initial_node_count = 1

  release_channel {
    channel = "REGULAR" # (RAPID,REGULAR,STABLE) specifies how Frequently the cluster will be updated
  }

#>>>LOGGING<<<|
logging_config {
  enable_components = ["APISERVER", "SYSTEM_COMPONENTS", "WORKLOADS"]
}
#>>>
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-axii"
    services_secondary_range_name = "service-vesimir"
  }
#>>>  
  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }
#>>>
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true #sometimes true sometimes false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  deletion_protection = false #Don't Forget this so you can tear down.

  #Workload identity For Bucket Access
  workload_identity_config {
  workload_pool = "pooper-scooper.svc.id.goog"
  }
}
#>>>>>

#I AM WORKLOAD IDENTITY
resource "google_service_account_iam_member" "bucket-head" {
  service_account_id = "projects/pooper-scooper/serviceAccounts/876288284083-compute@developer.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:pooper-scooper.svc.id.goog[staging/bucket-head]"
}
#>>>>>

#Node-Pools--------------------------------------------------------------------

# Node-Pool-1
resource "google_container_node_pool" "node-pool-1" {
  name       = var.kube.pool_name1
  location   = var.kube.subnet_region
  node_locations = ["europe-west10-a"] #>>> This specifies the zone of your nodes when operating on tools limited by location
  cluster    = var.kube.fleet_name
  # node_count = 1

  autoscaling {
    min_node_count = var.kube.min_count1
    max_node_count = var.kube.max_count1
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  #>>>>>
    node_config {     
    machine_type    = "n2-standard-8" #n2-standard-8 or c2-standard-8 for Gamestreaming; e2-standard-4 for general
    image_type = "UBUNTU_CONTAINERD" 
    preemptible = false
    labels = {
      role      = "sardaukar"
      kafka     = "true" # These tie to Pod affinity ensuring even distribtion of pods across nodes
      zookeeper = "true"
    }
    service_account = "876288284083-compute@developer.gserviceaccount.com"#
    oauth_scopes    = [ # Defines outside services which can help manage cluster at extra cost:
      /*"https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",*/
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  depends_on = [google_container_cluster.fleet-1]
}
#>>>

# Node-Pool-2
resource "google_container_node_pool" "node-pool-2" {
  name       = var.kube.pool_name2
  location   = var.kube.subnet_region
  node_locations = ["europe-west10-b"] #>>> This specifies the zone of your nodes when operating on tools limited by location
  cluster    = var.kube.fleet_name
  # node_count = 1

  autoscaling {
    min_node_count = var.kube.min_count2
    max_node_count = var.kube.max_count2
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  #>>>>>
    node_config {     
    machine_type    = "n2-standard-8" #n2-standard-8 or c2-standard-8 for Gamestreaming; e2-standard-4 for general
    image_type = "UBUNTU_CONTAINERD" 
    preemptible = false
    labels = {
      role      = "fremen"
      kafka     = "true" # These tie to Pod affinity ensuring even distribtion of pods across nodes
      zookeeper = "true"
    }
    service_account = "876288284083-compute@developer.gserviceaccount.com"#
    oauth_scopes    = [ # Defines outside services which can help manage cluster at extra cost:
      /*"https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",*/
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  depends_on = [google_container_cluster.fleet-1]
}
#>>>

# Node-Pool-3
resource "google_container_node_pool" "node-pool-3" {
  name       = var.kube.pool_name3
  location   = var.kube.subnet_region
  cluster    = var.kube.fleet_name
  node_locations = ["europe-west10-c"] #>>> This specifies the zone of your nodes when operating on tools limited by location
  # node_count = 1

  autoscaling {
    min_node_count = var.kube.min_count3
    max_node_count = var.kube.max_count3
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  #>>>>>
    node_config {     
    machine_type    = "n2-standard-8" #n2-standard-8 or c2-standard-8 for Gamestreaming; e2-standard-4 for general
    image_type = "UBUNTU_CONTAINERD" 
    preemptible = false
    labels = {
      role      = "bene-gesserit"
      kafka     = "true" # These tie to Pod affinity ensuring even distribtion of pods across nodes
      zookeeper = "true"
    }
    service_account = "876288284083-compute@developer.gserviceaccount.com"#
    oauth_scopes    = [ # Defines outside services which can help manage cluster at extra cost:
      /*"https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",*/
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  depends_on = [google_container_cluster.fleet-1]
}
#>>>>>