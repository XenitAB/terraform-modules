variable "cloud_provider" {
  description = "Cloud provider to use."
  type        = string
  default     = "azure"
}

variable "azure_config" {
  description = "AWS specific configuration"
  type = object({
    subscription_id           = string,
    resource_group            = string,
    client_id                 = string,
    resource_id               = string,
    storage_account_name      = string,
    storage_account_container = string
  })
  default = {
    subscription_id           = ""
    tenant_id                 = ""
    resource_group            = ""
    client_id                 = ""
    resource_id               = ""
    storage_account_name      = ""
    storage_account_container = ""
  }
}

variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn     = string,
    region       = string,
    s3_bucket_id = string
  })
  default = {
    role_arn     = ""
    region       = ""
    s3_bucket_id = ""
  }
}

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}
