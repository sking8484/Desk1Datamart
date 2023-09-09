# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "hosted_zone_id" {
  description = "AWS Hosted Zone ID for deskonecloud.com"
  type = string
  default = "Z040527814BU58MCAKPS0"
}

variable "docker_ami" {
  description = "Ubuntu AMI us-east-2 with docker and docker compose"
  type = string
  default = "ami-0fe63ffb5639dc6df"
}
