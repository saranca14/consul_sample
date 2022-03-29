
## Load Balancer SG
resource "aws_security_group" "load_balancer" {
  name_prefix = "${var.main_project_tag}-alb-sg"
  description = "Firewall for the application load balancer fronting the consul server."
  vpc_id      = aws_vpc.consul.id
  tags = merge(
    { "Name" = "${var.main_project_tag}-alb-sg" },
    { "Project" = var.main_project_tag }
  )
}

resource "aws_security_group_rule" "load_balancer_allow_80" {
  security_group_id = aws_security_group.load_balancer.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = var.allowed_traffic_cidr_blocks
  ipv6_cidr_blocks  = length(var.allowed_traffic_cidr_blocks_ipv6) > 0 ? var.allowed_traffic_cidr_blocks_ipv6 : null
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "load_balancer_allow_443" {
  security_group_id = aws_security_group.load_balancer.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.allowed_traffic_cidr_blocks
  ipv6_cidr_blocks  = length(var.allowed_traffic_cidr_blocks_ipv6) > 0 ? var.allowed_traffic_cidr_blocks_ipv6 : null
  description       = "Allow HTTPS traffic."
}

resource "aws_security_group_rule" "load_balancer_allow_outbound" {
  security_group_id = aws_security_group.load_balancer.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = length(var.allowed_traffic_cidr_blocks_ipv6) > 0 ? ["::/0"] : null
  description       = "Allow any outbound traffic."
}

## Consul Server Instance SG

resource "aws_security_group" "consul_server" {
  name_prefix = "${var.main_project_tag}-consul-server-sg"
  description = "Firewall for the consul server."
  vpc_id      = aws_vpc.consul.id
  tags = merge(
    { "Name" = "${var.main_project_tag}-consul-server-sg" },
    { "Project" = var.main_project_tag }
  )
}

resource "aws_security_group_rule" "consul_server_allow_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.load_balancer.id
  description              = "Allow HTTP traffic from Load Balancer."
}

resource "aws_security_group_rule" "consul_server_allow_client_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow HTTP traffic from Consul Client."
}

resource "aws_security_group_rule" "consul_server_allow_client_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow LAN gossip traffic from Consul Client to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_client_8300" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8300
  to_port                  = 8300
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow RPC traffic from Consul Client to Server.  For client and server agents to send and receive data stored in Consul."
}

resource "aws_security_group_rule" "consul_server_allow_server_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Allow LAN gossip traffic from Consul Server to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_server_8300" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8300
  to_port                  = 8300
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Allow RPC traffic from Consul Server to Server.  For client and server agents to send and receive data stored in Consul."
}

resource "aws_security_group_rule" "consul_server_allow_outbound" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."
}

## Consul Client Instance SG

resource "aws_security_group" "consul_client" {
  name_prefix = "${var.main_project_tag}-consul-client-sg"
  description = "Firewall for the consul client."
  vpc_id      = aws_vpc.consul.id
  tags = merge(
    { "Name" = "${var.main_project_tag}-consul-client-sg" },
    { "Project" = var.main_project_tag }
  )
}

resource "aws_security_group_rule" "consul_client_allow_8500" {
  security_group_id        = aws_security_group.consul_client.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.load_balancer.id
  description              = "Allow HTTP traffic from Load Balancer."
}

resource "aws_security_group_rule" "consul_client_allow_lb_9090" {
  security_group_id        = aws_security_group.consul_client.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.load_balancer.id
  description              = "Allow traffic from Load Balancer to Consul Clients for Fake Service."
}

resource "aws_security_group_rule" "consul_client_allow_9090" {
  security_group_id        = aws_security_group.consul_client.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow traffic from Consul Clients for Fake Service."
}

resource "aws_security_group_rule" "consul_client_allow_outbound" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."
}