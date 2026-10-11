variable "validating_webhook_configurations" {
  description = <<EOT
Map of validating_webhook_configurations, attributes below
Required:
    - metadata (block):
        - annotations (optional)
        - generate_name (optional)
        - labels (optional)
        - name (optional)
    - webhook (block):
        - admission_review_versions (optional)
        - client_config (required, block):
            - ca_bundle (optional)
            - service (optional, block):
                - name (required)
                - namespace (required)
                - path (optional)
                - port (optional)
            - url (optional)
        - failure_policy (optional)
        - match_policy (optional)
        - name (required)
        - namespace_selector (optional, block):
            - match_expressions (optional, block):
                - key (optional)
                - operator (optional)
                - values (optional)
            - match_labels (optional)
        - object_selector (optional, block):
            - match_expressions (optional, block):
                - key (optional)
                - operator (optional)
                - values (optional)
            - match_labels (optional)
        - rule (optional, block):
            - api_groups (required)
            - api_versions (required)
            - operations (required)
            - resources (required)
            - scope (optional)
        - side_effects (optional)
        - timeout_seconds (optional)
EOT

  type = map(object({
    metadata = object({
      annotations   = optional(map(string))
      generate_name = optional(string)
      labels        = optional(map(string))
      name          = optional(string)
    })
    webhook = list(object({
      admission_review_versions = optional(list(string))
      client_config = object({
        ca_bundle = optional(string)
        service = optional(object({
          name      = string
          namespace = string
          path      = optional(string)
          port      = optional(number)
        }))
        url = optional(string)
      })
      failure_policy = optional(string)
      match_policy   = optional(string)
      name           = string
      namespace_selector = optional(object({
        match_expressions = optional(list(object({
          key      = optional(string)
          operator = optional(string)
          values   = optional(set(string))
        })))
        match_labels = optional(map(string))
      }))
      object_selector = optional(object({
        match_expressions = optional(list(object({
          key      = optional(string)
          operator = optional(string)
          values   = optional(set(string))
        })))
        match_labels = optional(map(string))
      }))
      rule = optional(list(object({
        api_groups   = list(string)
        api_versions = list(string)
        operations   = list(string)
        resources    = list(string)
        scope        = optional(string)
      })))
      side_effects    = optional(string)
      timeout_seconds = optional(number)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.validating_webhook_configurations : (
        length(v.webhook) >= 1
      )
    ])
    error_message = "Each webhook list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.validating_webhook_configurations : (
        alltrue([for item in v.webhook : (item.timeout_seconds == null || (item.timeout_seconds >= 1 && item.timeout_seconds <= 30))])
      )
    ])
    error_message = "must be between 1 and 30"
  }
  # Note: 3 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

