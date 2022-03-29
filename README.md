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
*Service Discovery
*Resilient Service Mesh Deployments
*Secure by Default Networking

**2. High Availability architecture**

    **Recommended Architecture**

![image](https://user-images.githubusercontent.com/61488445/160543862-1b9bd467-9cff-4354-9432-6ca8a922fc8b.png)

HCP recommend deploying 5 nodes within the Consul cluster distributed between three availability zones as this architecture can withstand the loss of two nodes from within the cluster or the loss of an entire availability zone. 

A virtual private cloud (VPC) configured with public and private subnets across three Availability Zones. This provides the network infrastructure for HashiCorp Consul deployment.

#In the public subnets: 
Managed network address translation (NAT) gateways to allow outbound internet access for resources in the private subnets.*
Application Load Balancer attached to the Consul server cluster Auto Scaling group

#In the private subnets:
An Auto Scaling group for Consul clients.
An Auto Scaling group for a Consul server cluster. You can choose to create 3, 5, or 7 servers.
Script user data which install consul and update the configuration
