resource "kubernetes_validating_webhook_configuration" "validating_webhook_configurations" {
  for_each = var.validating_webhook_configurations


  metadata {
    annotations   = each.value.metadata.annotations
    generate_name = each.value.metadata.generate_name
    labels        = each.value.metadata.labels
    name          = each.value.metadata.name
  }

  dynamic "webhook" {
    for_each = each.value.webhook
    content {
      admission_review_versions = webhook.value.admission_review_versions
      client_config {
        ca_bundle = webhook.value.client_config.ca_bundle
        dynamic "service" {
          for_each = webhook.value.client_config.service != null ? [webhook.value.client_config.service] : []
          content {
            name      = service.value.name
            namespace = service.value.namespace
            path      = service.value.path
            port      = service.value.port
          }
        }
        url = webhook.value.client_config.url
      }
      failure_policy = webhook.value.failure_policy
      match_policy   = webhook.value.match_policy
      name           = webhook.value.name
      dynamic "namespace_selector" {
        for_each = webhook.value.namespace_selector != null ? [webhook.value.namespace_selector] : []
        content {
          dynamic "match_expressions" {
            for_each = namespace_selector.value.match_expressions != null ? namespace_selector.value.match_expressions : []
            content {
              key      = match_expressions.value.key
              operator = match_expressions.value.operator
              values   = match_expressions.value.values
            }
          }
          match_labels = namespace_selector.value.match_labels
        }
      }
      dynamic "object_selector" {
        for_each = webhook.value.object_selector != null ? [webhook.value.object_selector] : []
        content {
          dynamic "match_expressions" {
            for_each = object_selector.value.match_expressions != null ? object_selector.value.match_expressions : []
            content {
              key      = match_expressions.value.key
              operator = match_expressions.value.operator
              values   = match_expressions.value.values
            }
          }
          match_labels = object_selector.value.match_labels
        }
      }
      dynamic "rule" {
        for_each = webhook.value.rule != null ? webhook.value.rule : []
        content {
          api_groups   = rule.value.api_groups
          api_versions = rule.value.api_versions
          operations   = rule.value.operations
          resources    = rule.value.resources
          scope        = rule.value.scope
        }
      }
      side_effects    = webhook.value.side_effects
      timeout_seconds = webhook.value.timeout_seconds
    }
  }
}

