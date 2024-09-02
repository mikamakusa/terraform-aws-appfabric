## TAGS

variable "tags" {
  type    = map(string)
  default = {}
}

## DATAS

variable "aws_kms_key_id" {
  type    = string
  default = null
}

variable "firehose_delivery_stream_name" {
  type    = string
  default = null
}

variable "aws_s3_bucket" {
  type    = string
  default = null
}

## MODULES

variable "key" {
  type    = any
  default = []
}

variable "bucket" {
  type    = any
  default = []
}

## RESOURCES

variable "app_authorization" {
  type = list(object({
    id            = number
    app           = string
    app_bundle_id = any
    auth_type     = string
    credential = list(object({
      api_key_credential = optional(list(object({
        api_key = string
      })))
      oauth2_credential = optional(list(object({
        client_id     = string
        client_secret = string
      })))
    }))
    tenant = list(object({
      tenant_display_name = string
      tenant_identifier   = string
    }))
  }))
  default = []
}

variable "app_bundle" {
  type = list(object({
    id                      = number
    customer_managed_key_id = optional(any)
    tags                    = optional(map(string))
  }))
  default = []
}

variable "app_authorization_connection" {
  type = list(object({
    id                   = number
    app_bundle_id        = any
    app_authorization_id = any
    auth_request = optional(list(object({
      code         = string
      redirect_uri = optional(string)
    })))
  }))
  default = []
}

variable "ingestion" {
  type = list(object({
    id             = number
    app            = string
    app_bundle_id  = any
    ingestion_type = string
    tenant_id      = string
  }))
  default = []
}

variable "ingestion_destination" {
  type = list(object({
    id             = number
    ingestion_arn  = any
    app_bundle_arn = any
    tags           = optional(map(string))
    destination_configuration = list(object({
      audit_log = list(object({
        destination = list(object({
          firehose_stream = optional(list(object({
            streamname = optional(any)
          })))
          s3_bucket = optional(list(object({
            bucket_id = optional(any)
            prefix    = optional(string)
          })))
        }))
      }))
    }))
    processing_configuration = list(object({
      audit_log = list(object({
        format = string
        schema = string
      }))
    }))
  }))
  default = []
}
