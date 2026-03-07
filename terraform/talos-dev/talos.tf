data "aws_ami" "talos" {
    most_recent = true
    owners      = ["540036508848"] # Talos official AWS account
    name_regex = "talos-v[0-9]+\\.[0-9]+\\.[0-9]+-eu-west-2*"

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

output "talos_ami_id" {
    value = data.aws_ami.talos.id
}

resource "aws_instance" "talos-dev" {
    count                       = length(aws_subnet.talos-dev-subnets)
    ami                         = data.aws_ami.talos.id
    instance_type               = var.talos_instance_type
    subnet_id                   = aws_subnet.talos-dev-subnets[count.index].id
    vpc_security_group_ids      = [aws_security_group.talos-dev-cp-sg.id]
    associate_public_ip_address = true
    enable_primary_ipv6         = false
    user_data                   = file("${path.module}/controlplane.yaml")

    tags = {
        Name = "talos-dev-${count.index + 1}"
    }
}

resource "aws_lb_target_group_attachment" "talos-dev-nlb-tg-attachment" {
    count            = length(aws_instance.talos-dev)
    target_group_arn = aws_lb_target_group.talos-dev-nlb-tg.arn
    target_id        = aws_instance.talos-dev[count.index].id
    port             = 6443
}

resource "aws_lb_target_group_attachment" "talos-dev-nlb-tg-api-attachment" {
    count            = length(aws_instance.talos-dev)
    target_group_arn = aws_lb_target_group.talos-dev-nlb-tg-api.arn
    target_id        = aws_instance.talos-dev[count.index].id
    port             = 50000
}

resource "aws_route53_record" "talos-dev-instances" {
    count   = min(3, length(aws_instance.talos-dev))
    zone_id = data.aws_route53_zone.selected.zone_id
    name    = "talos-dev-${count.index + 1}.${var.hosted_zone}"
    type    = "A"
    ttl     = 300
    records = [aws_instance.talos-dev[count.index].public_ip]
}