###
# Control Plane Security Group
resource "aws_security_group" "talos-dev-cp-sg" {
  name        = "talos-dev-cp-sg"
  description = "Security group for Talos control plane nodes"
  vpc_id      = aws_vpc.talos-dev-vpc.id

  tags = {
    Name = "talos-dev"
  }
}

###
# Talos API
resource "aws_security_group_rule" "allow_talos_api" {
  description       = "Allow Talos API access"
  type              = "ingress"
  security_group_id = aws_security_group.talos-dev-cp-sg.id
  cidr_blocks       = [aws_vpc.talos-dev-vpc.cidr_block]
  protocol          = "tcp"
  from_port         = 50000
  to_port           = 50000
}

###
# Kubernetes API
resource "aws_security_group_rule" "allow_k8s_api" {
  description       = "Allow Kubernetes API access"
  type              = "ingress"
  security_group_id = aws_security_group.talos-dev-cp-sg.id
  self              = true
  protocol          = "tcp"
  from_port         = 6443
  to_port           = 6443
}

###
# ETCd
# resource "aws_security_group_rule" "allow_etcd" {
#   description       = "Allow etcd access"
#   type              = "ingress"
#   security_group_id = aws_security_group.talos-dev-cp-sg.id
#   self              = true
#   protocol       = "tcp"
#   from_port         = 2379
#   to_port           = 2380
# }

###
# Internal Cluster Traffic
resource "aws_security_group_rule" "allow_internal" {
  description       = "Allow internal cluster traffic"
  type              = "ingress"
  security_group_id = aws_security_group.talos-dev-cp-sg.id
  self              = true
  protocol          = "-1"
  from_port         = -1
  to_port           = -1
}