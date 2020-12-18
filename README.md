# Auto_S3_Download_EC2
Download S3 objects uploaded at real time into EC instances

Architecture
-------------------

![alt text](https://github.com/kujalk/Auto_S3_Download_EC2/blob/main/Architecture.PNG)

Execution Methods
-------------------

1. Fill the values in terraform.tfvars [Change the AMI ID as per your region. Region is specified in Provider.tf]

2. terraform init

3. terraform apply -auto-approve

4. To destroy the resources -> terraform destroy -auto-approve
