/*Purpose - To deploy S3, CloudWatch Event, EC2, SSM custom document
Developer - K.Janarthanan
Date - 13/12/2020
*/

resource "aws_cloudwatch_event_rule" "s3-trigger" {
  name        = var.cloud_watchrule_name
  description = "To trigger the SSM document to capture which S3 is uploaded"

  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${var.uploadbucket}"
      ]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "ssm-target" {
  target_id = "S3Download"
  arn       = aws_ssm_document.trigger-script.arn
  rule      = aws_cloudwatch_event_rule.s3-trigger.name
  role_arn  = aws_iam_role.cloudwatch_ssm.arn

  run_command_targets {
    key    = "tag:Name"
    values = [var.EC2_Name]
  }

  input_transformer {
    input_paths = {
      Keyname = "$.detail.requestParameters.key"
    }
    input_template = <<EOF
{
"scriptPath": ["sh script.sh"],
"objectKey":[<Keyname>],
"workingDirectory":["/home/ec2-user"],
"executionTimeout":["3600"]
}
EOF
  }
}
