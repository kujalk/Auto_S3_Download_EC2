/*Purpose - To deploy S3, CloudWatch Event, EC2, SSM custom document
Developer - K.Janarthanan
Date - 13/12/2020
*/

resource "aws_cloudtrail" "enabletrail" {
  name                          = var.cloudtrailname
  s3_bucket_name                = aws_s3_bucket.logbucket.id
  s3_key_prefix                 = "upload"
  include_global_service_events = false
  depends_on                    = [aws_s3_bucket_policy.enablebucketpolicy]

  event_selector {
    read_write_type           = "All"
    include_management_events = false

    data_resource {
      type = "AWS::S3::Object"

      values = ["${aws_s3_bucket.uploadbucket.arn}/"]
    }
  }
}