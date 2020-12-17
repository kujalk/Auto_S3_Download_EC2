variable logbucket {
  type    = string
  default = ""
}

variable uploadbucket {
  type    = string
  default = ""
}

variable cloudtrailname {
  type    = string
  default = ""
}

variable SecurityGroup_Name {
  type    = string
  default = ""
}

variable EC2_Name {
  type    = string
  default = ""
}

variable EC2_Size {
  type    = string
  default = ""
}

variable AMI_ID {
  type    = string
  default = ""
}

variable rolename {
  type    = string
  default = ""
}

variable instanceprofile {
  type    = string
  default = ""
}

variable ssmdocumentname {
  type    = string
  default = ""
}

variable cloud_watchrule_name {
  type    = string
  default = ""
}

variable cloudwatch_ssm_rolename {
  type    = string
  default = ""
}

variable ssmpolicy {
  type    = string
  default = ""
}

variable s3policy {
  type    = string
  default = ""
}

#Shell script
locals {
  shell_script = <<EOF
    #!/bin/bash

    echo "
    #!/bin/bash
    echo File uploaded \$1 >> /home/ec2-user/alls3.txt
    aws s3 cp s3://${var.uploadbucket}/\"\$1\" \"\$1\"
    " >> /home/ec2-user/script.sh
    
    EOF
}
