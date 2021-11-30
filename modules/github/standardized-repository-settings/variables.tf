variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

variable "repository_description" {
  description = "Description for this repository"
  type        = string
  default     = "No description"
}

variable "repository_visibility" {
  description = "The visibility of the repository"
  type        = string
  default     = "private"
}

variable "github_token" {
  description = "Token used to access GitHub"
  type        = string
  sensitive   = true
}

variable "required_status_checks" {
  description = "Status checks that need to pass to merge a PR to this repository"
  type        = list(string)
  default     = ["test"]
}
