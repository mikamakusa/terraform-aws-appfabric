resource "aws_appfabric_app_authorization" "this" {
  count          = length(var.app_bundle) == 0 ? 0 : length(var.app_authorization)
  app            = lookup(var.app_authorization[count.index], "app")
  app_bundle_arn = try(element(aws_appfabric_app_bundle.this.*.arn, lookup(var.app_authorization[count.index], "app_bundle_id")))
  auth_type      = lookup(var.app_authorization[count.index], "auth_type")

  dynamic "credential" {
    for_each = lookup(var.app_authorization[count.index], "credential")
    content {
      dynamic "api_key_credential" {
        for_each = try(lookup(credential.value, "api_key_credential") == null ? [] : ["api_key_credential"])
        iterator = api
        content {
          api_key = sensitive(lookup(api.value, "api_key"))
        }
      }

      dynamic "oauth2_credential" {
        for_each = try(lookup(credential.value, "oauth2_credential") == null ? [] : ["oauth2_credential"])
        iterator = oau
        content {
          client_id     = sensitive(lookup(oau.value, "client_id"))
          client_secret = sensitive(lookup(oau.value, "client_secret"))
        }
      }
    }
  }

  dynamic "tenant" {
    for_each = lookup(var.app_authorization[count.index], "tenant")
    content {
      tenant_display_name = lookup(tenant.value, "tenant_display_name")
      tenant_identifier   = lookup(tenant.value, "tenant_identifier")
    }
  }
}

resource "aws_appfabric_app_bundle" "this" {
  count                    = length(var.app_bundle)
  customer_managed_key_arn = try(var.aws_kms_key_id != null ? data.aws_kms_key.this.arn : element(module.kms.*.key_arn, lookup(var.app_bundle[count.index], "customer_managed_key_id")))
  tags                     = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.app_bundle[count.index], "tags"))
}

resource "aws_appfabric_app_authorization_connection" "this" {
  count                 = (length(var.app_bundle) && length(var.app_authorization)) == 0 ? 0 : length(var.app_authorization_connection)
  app_bundle_arn        = try(element(aws_appfabric_app_bundle.this.*.arn, lookup(var.app_authorization_connection[count.index], "app_bundle_id")))
  app_authorization_arn = try(element(aws_appfabric_app_authorization.this.*.arn, lookup(var.app_authorization_connection[count.index], "app_authorization_id")))

  dynamic "auth_request" {
    for_each = try(lookup(var.app_authorization_connection[count.index], "auth_request") == null ? [] : ["auth_request"])
    iterator = auth
    content {
      code         = lookup(auth.value, "code")
      redirect_uri = lookup(auth.value, "redirect_uri")
    }
  }
}

resource "aws_appfabric_ingestion" "this" {
  count          = length(var.app_bundle) == 0 ? 0 : length(var.ingestion)
  app            = lookup(var.ingestion[count.index], "app")
  app_bundle_arn = try(element(aws_appfabric_app_bundle.this.*.arn, lookup(var.ingestion[count.index], "app_bundle_id")))
  ingestion_type = lookup(var.ingestion[count.index], "ingestion_type")
  tenant_id      = lookup(var.ingestion[count.index], "tenant_id")
  tags           = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.ingestion[count.index], "tags"))
}

resource "aws_appfabric_ingestion_destination" "this" {
  count          = (length(var.app_bundle) && length(var.ingestion)) == 0 ? 0 : length(var.ingestion_destination)
  ingestion_arn  = try(element(aws_appfabric_app_bundle.this.*.arn, lookup(var.ingestion_destination[count.index], "ingestion_id")))
  app_bundle_arn = try(element(aws_appfabric_ingestion.this.*.arn, lookup(var.ingestion_destination[count.index], "app_bundle_id")))
  tags           = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.ingestion_destination[count.index], "tags"))

  dynamic "destination_configuration" {
    for_each = lookup(var.ingestion_destination[count.index], "destination_configuration")
    iterator = des
    content {
      dynamic "audit_log" {
        for_each = lookup(des.value, "audit_log")
        iterator = audit
        content {
          dynamic "destination" {
            for_each = lookup(audit.value, "destination")
            iterator = dest
            content {
              dynamic "firehose_stream" {
                for_each = try(lookup(dest.value, "firehose_stream") == null ? [] : ["firehose_stream"])
                iterator = fire
                content {
                  stream_name = try(data.aws_kinesis_firehose_delivery_stream.this.name)
                }
              }
              dynamic "s3_bucket" {
                for_each = try(lookup(dest.value, "s3_bucket") == null ? [] : ["s3_bucket"])
                content {
                  bucket_name = try(var.aws_s3_bucket != null ? data.aws_s3_bucket.this.bucket : element(module.s3.*.s3_bucket_id, lookup(s3_bucket.value, "bucket_id")))
                  prefix      = lookup(s3_bucket.value, "prefix")
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "processing_configuration" {
    for_each = lookup(var.ingestion_destination[count.index], "processing_configuration")
    iterator = pro
    content {
      dynamic "audit_log" {
        for_each = lookup(pro.value, "audit_log")
        iterator = audit
        content {
          format = lookup(audit.value, "format")
          schema = lookup(audit.value, "schema")
        }
      }
    }
  }
}