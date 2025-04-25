/*NETWORK*/

#Host-Network
resource "google_compute_network" "net-1" {
  name                    = var.network.name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1500
}
#>>>

#Subnet-1
resource "google_compute_subnetwork" "sub-1" {
  name          = var.network.subnetwork_name
  ip_cidr_range = var.network.nodes_cidr_range
  region        = var.network.region
  network       = var.network.name
  private_ip_google_access = "true"
  depends_on = [ google_compute_network.net-1 ]
#>>>

#Secondary Ranges --> For Kubernetes
  secondary_ip_range {
    range_name    = "pod-axii" #Ranges for Pod addressing
    ip_cidr_range = var.network.pods_cidr_range
  }
  #>>>
  secondary_ip_range {
    range_name    = "service-vesimir" #Ranges for Service addressing
    ip_cidr_range = var.network.services_cidr_range
  }  
}
#>>>>>

/*FIREWALL-RULES*/

#Ingress-rule
resource "google_compute_firewall" "http-ingress" {
  name        = "public-transit"
  network     = var.network.name
  allow {
    protocol = "tcp"
    ports    = ["80","443","10250"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on = [ google_compute_network.net-1 ]
}
#>>>

#Health-Check
resource "google_compute_firewall" "health" {
  name        = "sook-doctor"
  network     = var.network.name
  allow {
    protocol = "tcp"
    ports    = ["10256"]
  }

  source_ranges = ["130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
  depends_on = [ google_compute_network.net-1 ]
}
#>>>

#Game-Server-Health-and-traffic
resource "google_compute_firewall" "game-cluster" {
  name        = "galaxy-grants-wandering-star"
  network     = var.network.name
  allow {
    protocol = "udp"
    ports    = ["7000-8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on = [ google_compute_network.net-1 ]
}
#>>>

#Allow IAP Access For Instance Management
resource "google_compute_firewall" "allow_iap" {
  name    = "secret-service"
  network = var.network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4
  target_tags   = ["allow-iap"]
  depends_on = [ google_compute_network.net-1 ]
}
#>>>
#IAP-CONFIGURATION
data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}
#>>>>>

