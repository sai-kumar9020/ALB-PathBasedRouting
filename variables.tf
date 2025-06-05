# Variables for the main Terraform configuration

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}


variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}

variable "project_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "ALB-PathBasedRouting"
    Environment = "Development"
    Terraform   = "true"
  }
}

variable "name" {
  type    = string
  default = "alb-path-based"
}