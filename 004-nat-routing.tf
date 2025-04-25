/*NAT-GATEWAY-CONFIG*/

#Cloud-Router
resource "google_compute_router" "via-cambria" {
  name    = "path-finder"
  region  = var.kube-det.subnet_region
  network = var.network-det.name
  depends_on = [module.network]
}
#>>>
#NAT-Gateway-Attatchment
resource "google_compute_router_nat" "nat-transit" {
  name                               = "highliner-1"
  router                             = google_compute_router.via-cambria.name
  region                             = var.kube-det.subnet_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
/*                                                      ^                                                  
                                                        |
 Allows NAT access for all resources without having to redfine protocals in case of Scaling or major infa changes.
*/ depends_on = [module.network]
}
#>>>

/*
See The Below Diagram for a visual model of the NAT Gateway
+-----------------------+      +------------------+
|    Private Subnet     |      | External Network |
|   (192.168.1.0/24)    |      |    (Internet)    |
|                       |      |                  |
|  +----------------+   |      |                  |
|  | Device A       |   |      |                  |
|  | IP: 192.168.1.2|   |      |                  |
|  +----------------+   |      |                  |
|  +----------------+   |      |                  |
|  | Device B       |   |      |                  |
|  | IP: 192.168.1.3|   |      |                  |
|  +----------------+   |      |                  |
|                       |      |                  |
|  +----------------+   |      |                  |
|  |   Router       |   |      |                  |
|  |  +----------+  |   |      |                  |
|  |  |NAT--Table|  |   |      |                  |
|  |  +----------+  |   |      |                  |
|  | IP: 192.168.1.1|---|------|>Public IP:X.X.X.X|
|  +----------------+   |      +------------------+
|                       |
+-----------------------+
*/