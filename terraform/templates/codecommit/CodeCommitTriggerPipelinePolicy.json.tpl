{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement001",
      "Action": [
        "codepipeline:StartPipelineExecution"
      ],
      "Effect": "Allow",
      "Resource": [
          "${aws_codepipeline_arn}"
        ]
    }
  ]
}