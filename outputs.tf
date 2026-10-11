output "validating_webhook_configurations_id" {
  description = "Map of id values across all validating_webhook_configurations, keyed the same as var.validating_webhook_configurations except keys with no id are omitted"
  value       = { for k, v in kubernetes_validating_webhook_configuration.validating_webhook_configurations : k => v.id if v.id != null && length(v.id) > 0 }
}
output "validating_webhook_configurations_metadata" {
  description = "Map of metadata values across all validating_webhook_configurations, keyed the same as var.validating_webhook_configurations except keys with no metadata are omitted"
  value       = { for k, v in kubernetes_validating_webhook_configuration.validating_webhook_configurations : k => one(v.metadata) if v.metadata != null && length(v.metadata) > 0 }
}
output "validating_webhook_configurations_webhook" {
  description = "Map of webhook values across all validating_webhook_configurations, keyed the same as var.validating_webhook_configurations except keys with no webhook are omitted"
  value       = { for k, v in kubernetes_validating_webhook_configuration.validating_webhook_configurations : k => v.webhook if v.webhook != null && length(v.webhook) > 0 }
}

