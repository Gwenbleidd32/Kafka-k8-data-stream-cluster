variable "network" { #When you us nested objects withina variable, to call upon your selected object, 
  type = object({ #you must use the dot notation.
    name                = string
    subnetwork_name     = string
    nodes_cidr_range    = string
    pods_cidr_range     = string
    services_cidr_range = string
    region              = string
  })
}