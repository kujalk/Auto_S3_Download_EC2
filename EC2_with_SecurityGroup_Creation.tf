/*Purpose - To deploy S3, CloudWatch Event, EC2, SSM custom document
Developer - K.Janarthanan
Date - 13/12/2020
*/

#Security Group
resource "aws_security_group" "main" {
  name        = var.SecurityGroup_Name
  description = "To allow SSH Traffic"


  tags = {
    Name = var.SecurityGroup_Name
  }

  ingress {
    description = "SSH Traffic Allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outside"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 instance creation
resource "aws_instance" "main" {
  ami                    = var.AMI_ID
  instance_type          = var.EC2_Size
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data_base64       = base64encode(local.shell_script)

  tags = {
    Name = var.EC2_Name
  }
}