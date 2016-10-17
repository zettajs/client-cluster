variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

# CoreOS
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-1c94e10b"
  }
}

variable "availability_zones" {
  default     = "us-east-1b,us-east-1a,us-east-1d,us-east-1e"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "m4.xlarge"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "10"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}
