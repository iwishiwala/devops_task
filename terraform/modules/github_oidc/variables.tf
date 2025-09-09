variable "role_name" {
  description = "Name of the IAM role for GitHub Actions"
  type        = string
  default     = "github-actions"
}

variable "github_repo" {
  description = "GitHub repository in the format 'org/repo'. If not provided, will be auto-detected from git remote"
  type        = string
  default     = ""
}

variable "github_branches" {
  description = "List of branches that can assume the role"
  type        = list(string)
  default     = ["main", "develop"]
}

variable "tags" {
  description = "A map of tags to add to the resources created"
  type        = map(any)
  default     = {}
}