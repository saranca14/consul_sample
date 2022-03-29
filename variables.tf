# General Variables
variable "main_project_tag" {
  description = "Tag that will be attached to all resources."
  type        = string
  default     = "consul"
}

variable "aws_default_region" {
  description = "The default region that all resources will be deployed into."
  type        = string
  default     = "us-east-1"
}

# VPC Variables
variable "vpc_cidr" {
  description = "Cidr block for the VPC.  Using a /16 or /20 Subnet Mask is recommended."
  type        = string
  default     = "10.255.0.0/20"
}

variable "vpc_instance_tenancy" {
  description = "Tenancy for instances launched into the VPC."
  type        = string
  default     = "default"
}

variable "vpc_tags" {
  description = "Additional tags to add to the VPC and its resources."
  type        = map(string)
  default     = {}
}

variable "vpc_public_subnet_count" {
  description = "The number of public subnets to create.  Cannot exceed the number of AZs in your selected region.  2 is more than enough."
  type        = number
  default     = 3
}

variable "vpc_private_subnet_count" {
  description = "The number of private subnets to create.  Cannot exceed the number of AZs in your selected region."
  type        = number
  default     = 3
}

# EC2 Variables
variable "ami_id" {
  description = "AMI ID to be used on all AWS EC2 Instances."
  type        = string
  default     = "ami-0747bdcabd34c712a" #Ubuntu 18.04 LTS (HVM), SSD Volume Type
}

variable "ec2_key_pair_name" {
  description = "An existing EC2 key pair used to access the servers"
  type        = string
  default     = "consul"
}

## Consul Servers
variable "server_desired_count" {
  description = "The desired number of consul servers.  For Raft elections, should be an odd number."
  type        = number
  default     = 5
}

variable "server_min_count" {
  description = "The minimum number of consul servers."
  type        = number
  default     = 3
}

variable "server_max_count" {
  description = "The maximum number of consul servers."
  type        = number
  default     = 5
}

## Consul Web Clients
variable "client_web_desired_count" {
  description = "The desired number of consul web clients."
  type        = number
  default     = 1
}

variable "client_web_min_count" {
  description = "The minimum number of consul web clients."
  type        = number
  default     = 1
}

variable "client_web_max_count" {
  description = "The maximum number of consul web clients."
  type        = number
  default     = 1
}

# Allowed Traffic into the Consul Server
variable "allowed_traffic_cidr_blocks" {
  description = "List of CIDR blocks allowed to send requests to your consul server endpoint.  Defaults to EVERYWHERE."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_traffic_cidr_blocks_ipv6" {
  description = "List of IPv6 CIDR blocks allowed to send requests to your consul server endpoint.  Defaults to EVERYWHERE."
  type        = list(string)
  default     = ["::/0"]
}