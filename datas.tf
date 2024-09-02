data "aws_default_tags" "this" {}

data "aws_kms_key" "this" {
  count  = try(var.aws_kms_key_id ? 1 : 0)
  key_id = try(var.aws_kms_key_id)
}

data "aws_kinesis_firehose_delivery_stream" "this" {
  count = try(var.firehose_delivery_stream_name ? 1 : 0)
  name  = try(var.firehose_delivery_stream_name)
}

data "aws_s3_bucket" "this" {
  count  = try(var.aws_s3_bucket ? 1 : 0)
  bucket = try(var.aws_s3_bucket)
}