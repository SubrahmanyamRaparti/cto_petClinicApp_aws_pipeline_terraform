{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "account": [
    "${account}"
  ],
  "time": [
    "${time}"
  ],
  "region": [
    "${region}"
  ],
  "resources": [
    "${aws_codecommit_repository_arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "repositoryName": [
      "${repositoryName}"
    ],
    "repositoryId": [
      "${repositoryId}"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "${referenceName}"
    ]
  }
}