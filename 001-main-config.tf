/*Terraform-Main-Config*/
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
 backend gcs {
    bucket = "armageddon-repository"
    credentials = "poop.json"
    prefix = "prod"
  }
 
}
#>>>

#Provider
provider google {
  # Configuration options
  credentials = var.bonnefete 
  project = var.project
  region = var.region-prod
}
#>>>>>

#Config-Variables

#Project
variable project {
    type= string
    default = "pooper-scooper"
    description = "ID Google project"
}
#>>>

#Region
variable region-prod {
    type= string
    default = "europe-central2"
    description = "Region Google project"
}
#>>>

#Key
variable "bonnefete" {
    type = string
    default = "poop.json"
    description = "Path to the service account key file"
}
#>>>