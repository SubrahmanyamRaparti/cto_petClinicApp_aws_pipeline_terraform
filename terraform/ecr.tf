resource "aws_ecr_repository" "cto_ecr" {
  name                 = "${var.prefix}-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"    
  }
  
#   force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.common_tags
}