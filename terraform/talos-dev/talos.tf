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