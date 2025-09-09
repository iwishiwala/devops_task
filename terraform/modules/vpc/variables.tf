variable "environment_name" {
  type        = string
  description = "Name of the environment (used for resource naming)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones to use"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Extra tags for public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Extra tags for private subnets"
  default     = {}
}