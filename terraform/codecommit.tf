# ------------------------------------------------------------------------------
# Code Commit
# ------------------------------------------------------------------------------

resource "aws_codecommit_repository" "cto_codecommit" {
  repository_name = "${var.prefix}-repository"
  description     = "Java application"
  default_branch  = "main"
  tags            = local.common_tags
}

# ------------------------------------------------------------------------------
# Code Commit IAM Management
# ------------------------------------------------------------------------------

resource "aws_iam_role" "cto_trigger_pipeline_role" {
  name = "EventBridgeCodeCommitTriggerRole"
  path = "/"
  # AWS Resource: https://docs.aws.amazon.com/batch/latest/userguide/CWE_IAM_role.html 
  assume_role_policy = file("templates/codecommit/AssumeRoleEventsPolicy.json")
  tags               = local.common_tags
}

data "template_file" "cto_trigger_pipeline_policy_template" {
  template = file("templates/codecommit/CodeCommitTriggerPipelinePolicy.json.tpl")
  vars = {
    aws_codepipeline_arn = "*"
    # aws_codepipeline_arn = aws_codepipeline.cto_codepipeline.arn
  }
}

resource "aws_iam_policy" "cto_trigger_pipeline_policy" {
  name   = "CodePipelineTriggerPipelinePolicy"
  path   = "/"
  policy = data.template_file.cto_trigger_pipeline_policy_template.rendered
  tags   = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cto_codecommit_attachment" {
  role       = aws_iam_role.cto_trigger_pipeline_role.name
  policy_arn = aws_iam_policy.cto_trigger_pipeline_policy.arn
}

# ------------------------------------------------------------------------------
# Code Commit Event Bridge Alert
# ------------------------------------------------------------------------------

data "template_file" "cto_cloudwatch_event_rule_template" {
  template = file("templates/codecommit/CodeCommitEventPattern.json.tpl")

  vars = {
    account                       = data.aws_caller_identity.current.account_id
    time                          = timestamp()
    region                        = data.aws_region.current.name
    aws_codecommit_repository_arn = aws_codecommit_repository.cto_codecommit.arn
    repositoryName                = aws_codecommit_repository.cto_codecommit.repository_name
    repositoryId                  = aws_codecommit_repository.cto_codecommit.repository_id
    referenceName                 = var.source_repo_branch
  }
}

resource "aws_cloudwatch_event_rule" "cto_cloudwatch_event_rule" {
  name           = "${local.prefix}-event-rule"
  description    = "Trigger pipeline upon change in codecommit"
  event_bus_name = "default"
  is_enabled     = true
  event_pattern  = data.template_file.cto_cloudwatch_event_rule_template.rendered
  role_arn       = aws_iam_role.cto_trigger_pipeline_role.arn
  tags           = local.common_tags
}
