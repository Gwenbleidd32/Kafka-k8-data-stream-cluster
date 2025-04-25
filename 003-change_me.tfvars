/*Change the Vaules of the below Variables to Modify the configuration of the deployment modules*/

#NETWORK
network-det = {
    name                = "griffin-school-network"
    subnetwork_name     = "kaer-seren-main"
    nodes_cidr_range    = "10.132.0.0/20"
    pods_cidr_range     = "10.4.0.0/14"
    services_cidr_range = "10.8.0.0/20"
    region              = "europe-west10"
}
#>>> 

#KUBERNETES
kube-det = {
    fleet_name      = "atreides-war-fleet"
    service         = "876288284083-compute@developer.gserviceaccount.com"
    subnet_region   = "europe-west10"
    #>>> NODE-POOL-1
    pool_name1      = "sardaukar"
    min_count1      = 1
    max_count1      = 2
    #>>> NODE-POOL-2
    pool_name2      = "fremen"
    min_count2      = 1
    max_count2      = 2
    #>>> NODE-POOL-3
    pool_name3      = "bene-gesserit"
    min_count3      = 1
    max_count3      = 2
}
#>>>

