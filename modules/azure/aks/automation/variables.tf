variable "aks_managed_identity" {
  description = "The id of the AKS managed identity"
  type        = string
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "alerts_enabled" {
  description = "If metric alerts on audit logs are enabled"
  type        = string
  default     = false
}

variable "alert_name" {
  description = "The name of an alert that should be disabled/enabled in automation runbook"
  type        = string
  default     = ""
}

variable "alerts_resource_group_name" {
  description = "The name of a resource group where metric alerts are defined"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

# Monthly occurence currently not supported
variable "aks_automation_config" {
  description = "AKS automation configuration"
  type = object({
    public_network_access_enabled = optional(bool, false),
    runbook_schedules = optional(list(object({
      name        = string,
      frequency   = string,
      interval    = optional(number, null),
      start_time  = string, # ISO 8601 format
      timezone    = optional(string, "Europe/Stockholm")
      expiry_time = optional(string, ""),
      description = string,
      week_days   = optional(list(string), []),
      operation   = string,
      node_pools  = optional(list(string), []),
    })), [])
  })
  default = {}

  validation {
    condition = length([
      for schedule in var.aks_automation_config.runbook_schedules : true
      if contains(["OneTime", "Day", "Hour", "Week"], schedule.frequency)
    ]) == length(var.aks_automation_config.runbook_schedules)
    error_message = "The frequency of the schedule must be either 'OneTime', 'Day', 'Hour', 'Week'."
  }
}

variable "storage_account_id" {
  description = "The log storage account id"
  type        = string
}

variable "aks_joblogs_retention_days" {
  description = "How many days to keep logs from automation jobs"
  type        = number
}