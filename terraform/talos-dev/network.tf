###
# VPC
resource "aws_vpc" "talos-dev-vpc" {
  cidr_block           = "10.10.10.0/26"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "talos-dev"
  }
}

###
# Internet Gateway
resource "aws_internet_gateway" "talos-dev-gw" {
  vpc_id = aws_vpc.talos-dev-vpc.id

  tags = {
    Name = "talos-dev"
  }
}

###
# Resillient Subnets Across all AZs
data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_subnet" "talos-dev-subnets" {
  count             = length(data.aws_availability_zones.azs.names)
  vpc_id            = aws_vpc.talos-dev-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.talos-dev-vpc.cidr_block, 2, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "talos-dev"
  }
}

###
# Route Table
resource "aws_route_table" "talos-dev" {
  vpc_id = aws_vpc.talos-dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.talos-dev-gw.id
  }

  tags = {
    Name = "talos-dev"
  }
}

resource "aws_route_table_association" "talos-dev" {
  count          = length(aws_subnet.talos-dev-subnets)
  subnet_id      = aws_subnet.talos-dev-subnets[count.index].id
  route_table_id = aws_route_table.talos-dev.id
}

###
# Network Load Balancer
resource "aws_lb" "talos-dev-nlb" {
  name               = "talos-dev-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.talos-dev-subnets : subnet.id]

  tags = {
    Name = "talos-dev"
  }
}

resource "aws_lb_target_group" "talos-dev-nlb-tg" {
  name        = "talos-k8s-api"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = aws_vpc.talos-dev-vpc.id
  target_type = "instance"

  health_check {
    protocol = "TCP"
  }

  tags = {
    Name = "talos-dev"
  }
}

resource "aws_lb_listener" "talos-dev-nlb-listener" {
  load_balancer_arn = aws_lb.talos-dev-nlb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.talos-dev-nlb-tg.arn
  }

  tags = {
    Name = "talos-dev"
  }
}

###
# Set Route 53 Record for NLB
data "aws_route53_zone" "selected" {
  name = var.hosted_zone
}

resource "aws_route53_record" "talos-dev" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "talos-dev.${var.hosted_zone}"
  type    = "A"

  alias {
    name                   = aws_lb.talos-dev-nlb.dns_name
    zone_id                = aws_lb.talos-dev-nlb.zone_id
    evaluate_target_health = true
  }

}