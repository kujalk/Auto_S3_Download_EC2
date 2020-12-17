/*Purpose - To deploy S3, CloudWatch Event, EC2, SSM custom document
Developer - K.Janarthanan
Date - 13/12/2020
*/

data "aws_caller_identity" "current" {}

#Create a role for EC2 instance to be assumed to contact SSM
resource "aws_iam_role" "s3monitor_role" {
  name = var.rolename

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    "Description" = "To monitor S3 objects"
  }
}

#Attach the SSM policy to the above EC2 role
resource "aws_iam_role_policy_attachment" "EC2-Attach" {
  role       = aws_iam_role.s3monitor_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Policy for the above role to oontact EC2 instance and to trigger SSM document
resource "aws_iam_policy" "iams3policy" {
  name        = var.s3policy
  description = "Allow EC2 instance to access the S3 buckets"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.uploadbucket}/*"
        }
    ]
}
EOF
}

#Attach the SSM policy to the above EC2 role
resource "aws_iam_role_policy_attachment" "EC2-S3Policy-Attach" {
  role       = aws_iam_role.s3monitor_role.name
  policy_arn = aws_iam_policy.iams3policy.arn
}

#Create an EC2 instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.instanceprofile
  role = aws_iam_role.s3monitor_role.name
}

#Role for CloudWatch Event to access SSM
resource "aws_iam_role" "cloudwatch_ssm" {
  name = var.cloudwatch_ssm_rolename

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    "Description" = "Role for CloudWatch Event to access SSM"
  }
}

#Policy for the above role to oontact EC2 instance and to trigger SSM document
resource "aws_iam_policy" "iamssmpolicy" {
  name        = var.ssmpolicy
  description = "Only allows this role to access instance and ssm document"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ssm:SendCommand",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/*": [
                        "${var.EC2_Name}"
                    ]
                }
            }
        },
        {
            "Action": "ssm:SendCommand",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:document/${var.ssmdocumentname}"
            ]
        }
    ]
}
EOF
}

#Attach the policy to the above Cloudwatch event role
resource "aws_iam_role_policy_attachment" "CloudwatchEvent-Attach" {
  role       = aws_iam_role.cloudwatch_ssm.name
  policy_arn = aws_iam_policy.iamssmpolicy.arn
}