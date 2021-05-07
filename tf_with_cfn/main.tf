variable "region" {
  description = "AWS region we are deploying to"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "S3 bucket to store TF remote state (use only '-' and alphanumerical characters; must be globally unique)"
  type        = string
}

data "template_file" "s3_cfn" {
  template = file("${path.module}/s3_cfn.yaml")
  vars = {
    bucket_name = var.bucket_name
  }
}

#resource "aws_cloudformation_stack" "tf_with_cfn_s3" {
#  name = "tf_with_cfn_s3"
#  template_body = data.template_file.s3_cfn.rendered
#}



resource "aws_cloudformation_stack" "tf_with_cfn_s3" {
  name = "tf-with-cfn-s3"

  parameters = {
    BucketNameParameter = var.bucket_name
  }

  template_body = <<STACK
Parameters:
  BucketNameParameter:
    AllowedPattern: ^[0-9a-zA-Z]+([0-9a-zA-Z-.]*[0-9a-zA-Z])*$
    ConstraintDescription: Bucket name can include numbers, lowercase letters, uppercase letters, periods (.), and hyphens (-). It cannot start or end with a hyphen (-).
    Type: String
    Description: Globally unique bucket name using characters and dashes.
Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Ref BucketNameParameter
      VersioningConfiguration:
        Status: Enabled
      AccessControl: Private
      # DeleteionPolicy: Retain
      PublicAccessBlockConfiguration:
        BlockPublicAcls: True
        BlockPublicPolicy: True
        IgnorePublicAcls: True
        RestrictPublicBuckets: True
      BucketEncryption: 
        ServerSideEncryptionConfiguration: 
        - ServerSideEncryptionByDefault:
            SSEAlgorithm: AES256        
Outputs:
  BucketArn:
    Value: 
      !GetAtt
        - S3Bucket
        - Arn
    Description: Arn of the Amazon S3 bucket.
STACK
}

output "bucket_arn" {
  value = aws_cloudformation_stack.tf_with_cfn_s3.outputs.BucketArn
}