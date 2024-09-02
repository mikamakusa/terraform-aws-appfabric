## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/terraform-aws-kms | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/terraform-aws-s3 | n/a |

## Module usage
### module
````terraform
module "appfabric" {
  source = "."
  app_authorization             = var.app_authorization
  app_bundle                    = var.app_bundle
  app_authorization_connection  = var.app_authorization_connection
  ingestion                     = var.ingestion
  ingestion_destination         = var.ingestion_destination
  aws_kms_key_id                = "appfabric_key_test"
  aws_s3_bucket                 = "appfabrice_bucket_test"
  tags = {
    terraform = "true"
    provider  = "aws"
    service   = "appfabric"
  }
}
````
### variables
````terraform
variable "app_authorization" {
  type = any
}
variable "app_bundle" {
  type = any
}
variable "app_authorization_connection" {
  type = any
}
variable "ingestion" {
  type = any
}
variable "ingestion_destination" {
  type = any
}
````
### tfvars
````terraform
app_authorization = [
  {
    id             = 0
    app            = "TERRAFORMCLOUD"
    app_bundle_arn = aws_appfabric_app_bundle.arn
    auth_type      = "apiKey"
    credential = [
      {
          api_key_credential = [
            {
              api_key = "exampleapikeytoken"
            }
          ]
      }
    ]
    tenant = [
      {
        tenant_display_name = "example"
        tenant_identifier   = "example"
      }
    ]
  }
]
app_bundle = [
  {
    id                       = 1
    tags = {
      Environment = "test"
    }
  }
]
app_authorization_connection = [
  {
    id                   = 3
    app_authorization_id = 0
    app_bundle_id        = 1
  }
]
ingestion = [
  {
    id             = 7
    app            = "OKTA"
    app_bundle_arn = 1
    tenant_id      = "example.okta.com"
    ingestion_type = "auditLog"
  }
]
ingestion_destination = [
  {
    id             = 9
    app_bundle_arn = 1
    ingestion_arn  = 7

    processing_configuration = [
      {
          audit_log = [
            {
              format = "json"
              schema = "raw"
            }
          ]
      }
    ]

    destination_configuration = [
      {
        audit_log = [
          {
            destination = [
              {
                s3_bucket = [
                  {
                    prefix = "app-"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
````

## Resources

| Name | Type |
|------|------|
| [aws_appfabric_app_authorization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization) | resource |
| [aws_appfabric_app_authorization_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization_connection) | resource |
| [aws_appfabric_app_bundle.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_bundle) | resource |
| [aws_appfabric_ingestion.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion) | resource |
| [aws_appfabric_ingestion_destination.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion_destination) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_kinesis_firehose_delivery_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kinesis_firehose_delivery_stream) | data source |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_authorization"></a> [app\_authorization](#input\_app\_authorization) | n/a | <pre>list(object({<br>    id            = number<br>    app           = string<br>    app_bundle_id = any<br>    auth_type     = string<br>    credential = list(object({<br>      api_key_credential = optional(list(object({<br>        api_key = string<br>      })))<br>      oauth2_credential = optional(list(object({<br>        client_id     = string<br>        client_secret = string<br>      })))<br>    }))<br>    tenant = list(object({<br>      tenant_display_name = string<br>      tenant_identifier   = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_app_authorization_connection"></a> [app\_authorization\_connection](#input\_app\_authorization\_connection) | n/a | <pre>list(object({<br>    id                   = number<br>    app_bundle_id        = any<br>    app_authorization_id = any<br>    auth_request = optional(list(object({<br>      code         = string<br>      redirect_uri = optional(string)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_app_bundle"></a> [app\_bundle](#input\_app\_bundle) | n/a | <pre>list(object({<br>    id                      = number<br>    customer_managed_key_id = optional(any)<br>    tags                    = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_aws_kms_key_id"></a> [aws\_kms\_key\_id](#input\_aws\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_aws_s3_bucket"></a> [aws\_s3\_bucket](#input\_aws\_s3\_bucket) | n/a | `string` | `null` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | `any` | `[]` | no |
| <a name="input_firehose_delivery_stream_name"></a> [firehose\_delivery\_stream\_name](#input\_firehose\_delivery\_stream\_name) | n/a | `string` | `null` | no |
| <a name="input_ingestion"></a> [ingestion](#input\_ingestion) | n/a | <pre>list(object({<br>    id             = number<br>    app            = string<br>    app_bundle_id  = any<br>    ingestion_type = string<br>    tenant_id      = string<br>  }))</pre> | `[]` | no |
| <a name="input_ingestion_destination"></a> [ingestion\_destination](#input\_ingestion\_destination) | n/a | <pre>list(object({<br>    id             = number<br>    ingestion_arn  = any<br>    app_bundle_arn = any<br>    tags           = optional(map(string))<br>    destination_configuration = list(object({<br>      audit_log = list(object({<br>        destination = list(object({<br>          firehose_stream = optional(list(object({<br>            streamname = optional(any)<br>          })))<br>          s3_bucket = optional(list(object({<br>            bucket_id = any<br>            prefix    = optional(string)<br>          })))<br>        }))<br>      }))<br>    }))<br>    processing_configuration = list(object({<br>      audit_log = list(object({<br>        format = string<br>        schema = string<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_key"></a> [key](#input\_key) | n/a | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_authorization_arn"></a> [app\_authorization\_arn](#output\_app\_authorization\_arn) | n/a |
| <a name="output_app_authorization_connection_id"></a> [app\_authorization\_connection\_id](#output\_app\_authorization\_connection\_id) | n/a |
| <a name="output_app_authorization_id"></a> [app\_authorization\_id](#output\_app\_authorization\_id) | n/a |
| <a name="output_app_bundle_arn"></a> [app\_bundle\_arn](#output\_app\_bundle\_arn) | n/a |
| <a name="output_app_bundle_id"></a> [app\_bundle\_id](#output\_app\_bundle\_id) | n/a |
| <a name="output_ingestion_destination_id"></a> [ingestion\_destination\_id](#output\_ingestion\_destination\_id) | n/a |
| <a name="output_ingestion_id"></a> [ingestion\_id](#output\_ingestion\_id) | n/a |
