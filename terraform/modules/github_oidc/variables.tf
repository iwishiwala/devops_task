variable "role_name" {
  description = "Name of the IAM role for GitHub Actions"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in the format 'org/repo'"
  type        = string
}

variable "github_branch" {
  description = "Branch that can assume the role"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "A map of tags to add to the resources created"
  type        = map(any)
  default     = {}
}