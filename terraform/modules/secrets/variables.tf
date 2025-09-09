variable "secrets" {
  description = "Map of secrets to create in AWS Secrets Manager"
  type = map(object({
    description = string
    value       = string
    tags        = map(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to the resources created"
  type        = map(any)
  default     = {}
}
