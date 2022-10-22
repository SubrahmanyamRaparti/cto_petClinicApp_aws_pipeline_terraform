locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    ProjectName         = var.project
    Environment         = terraform.workspace
    InfrastructureOwner = "Subrahmanyam"
    CreatedOn           = timestamp()
    ContactEmail        = "rv.subrahmanyam1@gmail.com"
  }
}