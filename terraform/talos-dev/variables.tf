variable "hosted_zone" {
  description = "The public domain for the environment"
  type        = string
}

variable "talos_instance_type" {
  description = "EC2 instance type for Talos nodes"
  type        = string
  default     = "t3.medium"
}