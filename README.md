# HA- Consul cluster in AWS Cloud

```
Contents:
1. HCP Consul
2. High Availability architecture
3. Scaling for Consul
4. Terraform for deployment
5. GUI of Consul
6. Maintanence of HCP consul
7. Cost Estimate
8. Future developments
```

**1. HCP Consul**

HCP Consul is a secure, resilient service mesh which enables platform operators to quickly deploy a fully managed, secure-by-default service mesh, helping developers discover and securely connect any application.
It offers:
• Service registry and health monitoring, to provide a real-time directory of all services
with their health status
• Network middleware automation, with service discovery for dynamic reconfiguration as
services scale up, scale down, or move
• Zero Trust network with service mesh, to secure service-to-service traffic with identity-
based security policies and encrypted traffic with Mutual-Transport Layer Security
(TLS)

**2. High Availability architecture**

    **Recommended Architecture**

![image](https://user-images.githubusercontent.com/61488445/160543862-1b9bd467-9cff-4354-9432-6ca8a922fc8b.png)

HCP recommend deploying 5 nodes within the Consul cluster distributed between three availability zones as this architecture can withstand the loss of two nodes from within the cluster or the loss of an entire availability zone. 

A virtual private cloud (VPC) configured with public and private subnets across three Availability Zones. This provides the network infrastructure for HashiCorp Consul deployment.

#In the public subnets: 
1. Managed network address translation (NAT) gateways to allow outbound internet access for resources in the private subnets.
2. Application Load Balancer attached to the Consul server cluster Auto Scaling group


#In the private subnets:
1. An Auto Scaling group for Consul clients.
2. An Auto Scaling group for a Consul server cluster. You can choose to create 3, 5, or 7 servers.
3. Script user data which install consul and update the configuration

**3. Scaling for Consul**

Auto scaling is enabled for Consul server cluster with each nodes in atleast 3 distinct availability zones for achieving high availability and Fault tolerance. Autocaling is attached to Application load balancer with target groups listening to port 8500. 
Health check for target group enabled and shows health status in dashboard. 
<img width="1068" alt="image" src="https://user-images.githubusercontent.com/61488445/160544761-b8f23d43-4440-4bdc-a654-b9974e17d9a0.png">


