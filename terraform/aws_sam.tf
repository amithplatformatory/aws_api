# ----------------------------------------------------------------------
# SAM deploy template S3 Object
# ----------------------------------------------------------------------
resource "aws_s3_bucket_object" "sam_deploy_object" {
  bucket = var.amithcodebucket
  key    = "sam-deploy-templates/${var.app_name}-deploy-${timestamp()}.yaml"
  source = "../sam/sam-deploy.yaml"
  etag   = filemd5("../sam/sam-deploy.yaml")
}

# ----------------------------------------------------------------------
# SAM Stack 
# ----------------------------------------------------------------------
resource "aws_cloudformation_stack" "employees_api_sam_stack" {
  name         = "${var.app_name}-sam-stack"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    AppName = var.app_name
  }

  template_url = "https://${var.amithcodebucket}.s3-ap-southeast-2.amazonaws.com/${aws_s3_bucket_object.sam_deploy_object.id}"
}
