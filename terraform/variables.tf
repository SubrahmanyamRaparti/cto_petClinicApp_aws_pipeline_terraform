variable "aws_region" {}

variable "prefix" {
  description = "project prefix"
  default     = "pet-clinic-app"
  type        = string
}

variable "project" {
  description = "Name of the project"
  default     = "Pet Clinic Java Application"
  type        = string
}

variable "source_repo_branch" {
  description = "Source branch name"
  default     = "main"
  type        = string
}

variable "family" {
  description = "Family of the Task Definition"
  default     = "petclinic"
  type        = string
}
