# ------------------------------------------------------------------------------
# Code Code Build
# ------------------------------------------------------------------------------

resource "aws_codebuild_project" "cto_codebuild_project" {
  name         = "${var.prefix}-project"
  description  = "Build project files"
  service_role = aws_iam_role.cto_codebuild_role.arn

  depends_on = [
    aws_ecr_repository.cto_ecr,
    aws_codecommit_repository.cto_codecommit
  ]

  build_timeout  = "10"
  queued_timeout = "10"

  # AWS Resource: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-artifacts.html
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.cto_ecr.repository_url
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.family
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    image_pull_credentials_type = "CODEBUILD"
    image                       = "aws/codebuild/standard:4.0"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("templates/codebuild/buildspec.yml")
  }

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# Code Commit IAM Management
# ------------------------------------------------------------------------------

resource "aws_iam_role" "cto_codebuild_role" {
  name = "CodeBuildRole"
  path = "/"
  # AWS Resource: https://docs.aws.amazon.com/batch/latest/userguide/CWE_IAM_role.html 
  assume_role_policy = file("templates/codebuild/AssumeRoleCodebuildPolicy.json")
  tags               = local.common_tags
}

data "template_file" "cto_codebuild_policy_template" {
  template = file("templates/codebuild/CodeBuildPolicy.json.tpl")
  vars = {
    aws_ecr_repository_arn  = aws_ecr_repository.cto_ecr.arn
    cto_artifact_bucket_arn = aws_s3_bucket.cto_artifact_bucket.arn
  }
}

resource "aws_iam_policy" "cto_codebuild_policy" {
  name   = "CodeBuildPolicy"
  path   = "/"
  policy = data.template_file.cto_codebuild_policy_template.rendered
  tags   = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cto_codebuild_attachment" {
  role       = aws_iam_role.cto_codebuild_role.name
  policy_arn = aws_iam_policy.cto_codebuild_policy.arn
}
