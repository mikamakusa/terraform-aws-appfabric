module "kms" {
  source = "./modules/terraform-aws-kms"
  key    = var.key
}

module "s3" {
  source = "./modules/terraform-aws-s3"
  bucket = var.bucket
}