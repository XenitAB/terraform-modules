variable "aks_name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "aks_name_suffix" {
  description = "The suffix for the aks clusters"
  type        = number
}

variable "azure_policy_config" {
  description = "A list of Azure policy mutations to create and include in the XKS policy set definition"
  type = object({
    exclude_namespaces = list(string)
    mutations = list(object({
      name         = string
      display_name = string
      template     = string
    }))
  })
  default = {
    exclude_namespaces = [
      "linkerd",
      "linkerd-cni",
      "velero",
      "grafana-agent",
    ]
    mutations = [
      {
        name         = "ContainerNoPrivilegeEscalation"
        display_name = "Containers should not use privilege escalation"
        template     = "container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "ContainerDropCapabilities"
        display_name = "Containers should drop disallowed capabilities"
        template     = "container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "ContainerReadOnlyRootFs"
        display_name = "Containers should use a read-only root filesystem"
        template     = "container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "EphemeralContainerNoPrivilegeEscalation"
        display_name = "Ephemeral containers should not use privilege escalation"
        template     = "ephemeral-container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "EphemeralContainerDropCapabilities"
        display_name = "Ephemeral containers should drop disallowed capabilities"
        template     = "ephemeral-container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "EphemeralContainerReadOnlyRootFs"
        display_name = "Ephemeral containers should use a read-only root filesystem"
        template     = "ephemeral-container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "InitContainerNoPrivilegeEscalation"
        display_name = "Init containers should not use privilege escalation"
        template     = "init-container-disallow-privilege-escalation.yaml.tpl"
      },
      {
        name         = "InitContainerDropCapabilities"
        display_name = "Init containers should drop disallowed capabilities"
        template     = "init-container-drop-capabilities.yaml.tpl"
      },
      {
        name         = "InitContainerReadOnlyRootFs"
        display_name = "Init containers should use a read-only root filesystem"
        template     = "init-container-read-only-root-fs.yaml.tpl"
      },
      {
        name         = "PodDefaultSecComp"
        display_name = "Pods should use an allowed seccomp profile"
        template     = "k8s-pod-default-seccomp.yaml.tpl"
      },
      {
        name         = "PodServiceAccountTokenNoAutoMount"
        display_name = "Pods should not automount service account tokens"
        template     = "k8s-pod-serviceaccount-token-false.yaml.tpl"
      },
    ]
  }
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "tenant_namespaces" {
  description = "List of tenant namespaces for Flux"
  type        = list(string)
  default     = []
}

variable "envoy_tls_policy_enabled" {
  description = "An option to remove the gatekeeper mutation for tls settings"
  type        = bool
  default     = true
}
