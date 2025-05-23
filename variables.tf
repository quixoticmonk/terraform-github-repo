variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  default = "github-demo"
}

variable "repository_description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility: public or private"
  type        = string
  default     = "public"
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
  default = "quixoticmonk"
}
