output "Clone_HTTPS" {
  value = aws_codecommit_repository.cto_codecommit.clone_url_http
}

output "Clone_SSH" {
  value = aws_codecommit_repository.cto_codecommit.clone_url_ssh
}

output "ECR_URI" {
  value = aws_ecr_repository.cto_ecr.repository_url
}