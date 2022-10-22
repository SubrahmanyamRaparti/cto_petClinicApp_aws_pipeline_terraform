#!/bin/bash

# Script to configure the AWS region.

TF_VAR_aws_region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

echo "export TF_VAR_aws_region=${TF_VAR_aws_region}" >> ~/.bash_profile

echo "Awesome! You are in $TF_VAR_aws_region region."