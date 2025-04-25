/* CLUSTER PERSISTENT DISKS */

#Graphana disk
resource "google_compute_disk" "grafana_disk" {
  name  = "grafana-disk"
  type  = "pd-standard"
  zone  = "europe-west10-a"
  size  = "10"
}
#>>>

#Splunk disk-1
resource "google_compute_disk" "spunk_1" {
  name  = "splunk-disk-1"
  type  = "pd-standard"
  zone  = "europe-west10-a"
  size  = "10"
}
#>>>

#Splunk disk-2
resource "google_compute_disk" "spunk_2" {
  name  = "splunk-disk-2"
  type  = "pd-standard"
  zone  = "europe-west10-a"
  size  = "10"
}
#>>> 