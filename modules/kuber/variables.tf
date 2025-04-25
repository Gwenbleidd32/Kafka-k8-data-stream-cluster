variable "kube" { #When you us nested objects withina variable, to call upon your selected object, 
  type = object({ #you must use the dot notation.
    #>>> FLEET-SETTINGS
    fleet_name    = string
    service       = string
    net_name      = string
    subnet_name   = string
    subnet_region = string

    #>>> NODE-POOL-1
    pool_name1       = string
    min_count1       = number
    max_count1       = number
    #>>> NODE-POOL-2
    pool_name2      = string
    min_count2      = number
    max_count2      = number
    #>>> NODE-POOL-3
    pool_name3      = string
    min_count3      = number
    max_count3      = number
  })   
}
#>>>