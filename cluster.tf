# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_autoscaling_group" "load-test-cluster" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.load-test-cluster-lc.name}"

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "load-test-cluster"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "load-test-cluster-lc" {
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${aws_security_group.default.id}"]
  user_data       = "${file(".user-data")}"
  key_name        = "${var.key_name}"
}

# Our default security group to access
# the instances over SSH
resource "aws_security_group" "default" {
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
