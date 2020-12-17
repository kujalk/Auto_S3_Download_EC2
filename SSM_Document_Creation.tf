/*Purpose - To deploy S3, CloudWatch Event, EC2, SSM custom document
Developer - K.Janarthanan
Date - 13/12/2020
*/

#Custom SSM document to trigger the script
resource "aws_ssm_document" "trigger-script" {
  name          = var.ssmdocumentname
  document_type = "Command"

  content = <<DOC
 {
  "schemaVersion": "2.2",
  "description": "Pass previous status to local script.",
  "parameters": {
    "scriptPath": {
      "type": "String",
      "maxChars": 4096
    },
    "objectKey": {
      "type": "String",
      "maxChars": 100
    },
    "workingDirectory": {
      "type": "String",
      "default": "",
      "maxChars": 4096
    },
    "executionTimeout": {
      "type": "String",
      "default": "3600",
      "allowedPattern": "([1-9][0-9]{0,4})|(1[0-6][0-9]{4})|(17[0-1][0-9]{3})|(172[0-7][0-9]{2})|(172800)"
    }
  },
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "runShellScript",
      "inputs": {
        "runCommand": [
          "{{ scriptPath }} '{{ objectKey}}'"
        ],
        "workingDirectory": "{{ workingDirectory }}",
        "executionTimeout": "{{ executionTimeout }}"
      }
    }
  ]
}
DOC
}