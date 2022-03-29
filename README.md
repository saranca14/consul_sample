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
1. Service registry and health monitoring, to provide a real-time directory of all services with their health status.
2. Network middleware automation, with service discovery for dynamic reconfiguration as services scale up, scale down, or move.
3. Zero Trust network with service mesh, to secure service-to-service traffic with identity-based security policies and encrypted traffic with Mutual Transport Layer Security.

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

**Health check for target group enabled and shows health status in dashboard:**
<img width="1068" alt="image" src="https://user-images.githubusercontent.com/61488445/160544761-b8f23d43-4440-4bdc-a654-b9974e17d9a0.png">

**Load balancer endpoint DNS is used for accessing Consul GUI:**
<img width="1095" alt="image" src="https://user-images.githubusercontent.com/61488445/160545056-57f39bbf-789c-4d7f-a479-5adf9b67391c.png">

**Autoscaling parameters such as shown below is set as variables in terraform code with default value set to 5.**
```
desired_capacity = var.server_desired_count
min_size = var.server_min_count
max_size = var.server_max_count
```
**4. Terraform for deployment**

Terraform is a powerful IaC tool used here to automate the Consul deployment. This helps to easily recreate same environments and deployments in short span.Currently Module is available for Consul and not used in this deployments. This code can be further enhanced with integrating modules.

Terraform code has below files:
```
1. vpc.tf :> This template creates the VPC with 3 public subnets and 3 private subnets, Internet gateway, Associated Route tables and NAT gateway.
2. vpc-sg.tf :> This template creates Security group and rules for Consul server, Consul clients. (New Security groups can be added if new clients/bastion host is introduced).
3. iam.tf :> This template includes IAM profile, Roles and policy creation.
4. ec2-asg.tf :> This template includes Auto scaling definition for Consul servers and Consul clients.
5. ec2-launch-templates.tf :> Launch template for ASG is defined for both Consul servers and clients.
6. main.tf :> Provider block and data source for Availability zones, region etc
7. Scripts: 2 files each for Consul server and Consul client install+ configuration. This is passed as user data.
8. Variables.tf :> Variables are defined in this file.
```

Two scripts : server.sh and client.sh

**server.sh**
1. Install Consul package.
2. Modify the default consul.hcl file with below parameters:
```
data_dir = "/opt/consul"
client_addr = "0.0.0.0"
ui_config{
  enabled = true
}
server = true
bind_addr = "0.0.0.0"
advertise_addr = "$local_ip"
bootstrap_expect=${BOOTSTRAP_NUMBER}
retry_join = ["provider=aws tag_key=\"${PROJECT_TAG}\" tag_value=\"${PROJECT_VALUE}\""]
```
3. Start and enable Consul service.

**client.sh**
1. Install Consul package.
2. Modify the default consul.hcl file with below parameters:
```
data_dir = "/opt/consul"
client_addr = "0.0.0.0"
server = false
log_level           = "INFO"
ui                  = true
bind_addr = "0.0.0.0"
advertise_addr = "$local_ip"
retry_join = ["provider=aws tag_key=\"${PROJECT_TAG}\" tag_value=\"${PROJECT_VALUE}\""]
```
3. Start and enable Consul service.
