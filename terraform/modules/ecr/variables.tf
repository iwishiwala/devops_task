variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "ECR lifecycle policy configuration"
  type = object({
    keep_tagged_images = number
    untagged_days      = number
  })
  default = {
    keep_tagged_images = 10
    untagged_days      = 1
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
