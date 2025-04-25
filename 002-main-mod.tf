/*NETWORK*/

#NETWORK-MODULE
module "network" {
  source = "./modules/network"
  network = {
    name = var.network-det.name
    subnetwork_name     = var.network-det.subnetwork_name
    nodes_cidr_range    = var.network-det.nodes_cidr_range
    pods_cidr_range     = var.network-det.pods_cidr_range
    services_cidr_range = var.network-det.services_cidr_range
    region              = var.network-det.region
  }
}
#>>>

#KUBERNETES-MODULE
module "kuber" {
  source = "./modules/kuber"
  kube = {
    #>>> FLEET-SETTINGS
    fleet_name    = var.kube-det.fleet_name
    net_name      = var.network-det.name
    subnet_name   = var.network-det.subnetwork_name
    subnet_region = var.network-det.region
    service       = var.kube-det.service
    #>>> NODE-POOL-1
    pool_name1      = var.kube-det.pool_name1
    min_count1      = var.kube-det.min_count2
    max_count1      = var.kube-det.max_count3
    #>>> NODE-POOL-2
    pool_name2      = var.kube-det.pool_name2
    min_count2      = var.kube-det.min_count2
    max_count2      = var.kube-det.max_count2
    #>>> NODE-POOL-3
    pool_name3      = var.kube-det.pool_name3
    min_count3      = var.kube-det.min_count3
    max_count3      = var.kube-det.max_count3
  }
  depends_on = [module.network]
}
#>>>>>

/*VARIABLES*/

variable "network-det" { #When you us nested objects withina variable, to call upon your selected object, 
  type = object({ #you must use the dot notation.
    name                = string
    subnetwork_name     = string
    nodes_cidr_range    = string
    pods_cidr_range     = string
    services_cidr_range = string
    region              = string
  })
}
#>>>

variable "kube-det" { #When you us nested objects within a variable, to call upon your selected object, 
  type = object({ #you must use the dot notation.
    #>>> FLEET-SETTINGS
    fleet_name    = string
    subnet_region = string
    service       = string
    #>>> NODE-POOL-1
    pool_name1      = string
    min_count1      = number
    max_count1      = number
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
#>>>>>

#WHAT ARE KUBERNETES CLUSTERS? (Visual Representation Below)

/*
Refer to the below diagram  for an intuitive Visulization of the Kubernetes Cluster. 
 
1. The Control plane is the master node that manages and administer's settings and configurations for the worker nodes.
- Note --> Issuing commandds in kubectl communicates with the API server, which in turn communicates with the control plane.

2. The Service Layer acts as an endpoint and a load balancer for the worker nodes, and directs inbound client traffic based on the configured labels, and cluster IP.

3. The kube-proxy: Maintains network rules on nodes, allowing network communication to pods from inside or outside the cluster.

+----------------------------------------------------------+
|                   Kubernetes Cluster                     |
|                                                          |
|  +------------------------+     +---------------------+  |
|  |   Control Plane Node   |     |     Worker Node     |  |
|  |                        |     |                     |  |
|  |  +------------------+  +-----+  +---------------+  |  |
|  |  |    API Server    |  >>>>>>>  |    kubelet    |  |  |
|  |  +------------------+  +-----+  +---------------+  |  |
|  |  |    Controller    |  |     |  |   kube-proxy  |  |  |
|  |  |      Manager     |  |     |  +---------------+  |  |
|  |  +------------------+  |     |  |      Pods     |  |  |
|  |  |     Scheduler    |  |     |  |               |  |  |
|  |  +------------------+  |     |  |  +----------+ |  |  |
|  |  |       etcd       |  |     |  |  | Pod A1   | |  |  |
|  |  +------------------+  |     |  |  | IP:      | |  |  |
|  |                        |     |  |  | 10.1.1.1 | |  |  |
|  +----------|v|-----------+     |  |  | label:   | |  |  |
|             |v|                 |  |  | app=a    | |  |  |
|  +--------- |v|-----------+     |  |  +----------+ |  |  |
|  |      Worker Node       |     |  |  +----------+ |  |  |
|  |                        |     |  |  | Pod A2   | |  |  |
|  |  +---------------+     |     |  |  | IP:      | |  |  |
|  |  |    kubelet    |     |     |  |  | 10.1.1.2 | |  |  |
|  |  +---------------+     |     |  |  | label:   | |  |  |
|  |  |   kube-proxy  |     |     |  |  | app=a    | |  |  |
|  |  +---------------+     |     |  |  +----------+ |  |  |
|  |  |      Pods     |     |     |  |               |  |  |
|  |  |               |     |     |  +---------------+  |  |
|  |  |  +----------+ |     |     |                     |  |
|  |  |  | Pod B1   | |     |     +----------^----------+  |
|  |  |  | IP:      | |     |                |             |
|  |  |  | 10.1.2.1 | |     |                |             |
|  |  |  | label:   | |     |                |             |
|  |  |  | app=b    | |     |                *             |
|  |  |  +----------+ |     |                |             |
|  |  +---------------+     |                |             |
|  +----------^-------------+                |             |
|  +----------|------------------------------v----------+  |
|  |          v         Service Layer                   |  |
|  |  +----------------------------------------------+  |  |
|  |  |   Service A (10.96.0.1)                      |  |  |
|  |  |   Cluster IP: 10.96.0.1                      |  |  |
|  |  |   Selects Pods: label: app=a                 |  |  |
|  |  +----------------------------------------------+  |  |
|  |  +----------------------------------------------+  |  |
|  |  |   Service B (10.96.0.2)                      |  |  |
|  |  |   Cluster IP: 10.96.0.2                      |  |  |
|  |  |   Selects Pods: label: app=b                 |  |  |
|  |  +----------------------------------------------+  |  |
|  +----------------------------------------------------+  |
+----------------------------------------------------------+

SEE BELOW FOR LIFECYCLE OF ISSUING COMMANDS THROUGH KUBECTL

+-----------------------------+
|       kubectl command       |
|     (e.g., kubectl get pods)|
+-------------+---------------+
              |
              v
+-------------+---------------+
|        kubeconfig file       |
|  (authentication details)    |
+-------------+---------------+
              |
              v
+-------------+---------------+
|       Kubernetes API Server  |
|  (validates authentication)  |
+-------------+---------------+
              |
              v
+-------------+---------------+
|     Authentication Mechanism |
|  (e.g., certs, tokens, etc.) |
+-------------+---------------+
              |
              v
+-------------+---------------+
| Authorization Mechanism (RBAC)|
|  (checks permissions)         |
+-------------+---------------+
              |
              v
+-------------+---------------+
|        Cluster Operations    |
|  (e.g., list pods, deploy)   |
+-----------------------------+
*/

