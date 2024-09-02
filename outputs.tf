output "app_authorization_arn" {
  value = try(aws_appfabric_app_authorization.this.*.arn)
}

output "app_authorization_id" {
  value = try(aws_appfabric_app_authorization.this.*.id)
}

output "app_authorization_connection_id" {
  value = try(aws_appfabric_app_authorization_connection.this.*.id)
}

output "app_bundle_id" {
  value = try(aws_appfabric_app_bundle.this.*.id)
}

output "app_bundle_arn" {
  value = try(aws_appfabric_app_bundle.this.*.arn)
}

output "ingestion_id" {
  value = try(aws_appfabric_ingestion.this.*.id)
}

output "ingestion_destination_id" {
  value = try(aws_appfabric_ingestion_destination.this.*.id)
}