# Variables for the Load Balancer module

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "security_groups" {
  description = "security groups"
  type        = list(string)
}
variable "public_subnets" {
  description = "IDs of the public subnets"
  type        = list(string)
}


variable "target_groups" {
  description = "Map of target groups to create"
  type = map(object({
    name = string
    path = string
    port = number
    priority = number
  }))
}

variable "name" {
  type = string
}