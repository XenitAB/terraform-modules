<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "credentials" {
  description = "List of credentials for Git Providers."
  type = list(object({
    type = string # azuredevops or github
    azure_devops = object({
      org = string
      pat = string
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    })
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
  }))
}

variable "fleet_infra" {
  description = "Configuration for Flux bootstrap repository."
  type = object({
    type = string
    org  = string
    proj = string
    repo = string
  })
=======
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> Add initial config
variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
  sensitive   = true
  default     = "null"
}

variable "azure_devops_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
  default     = "null"
}

variable "azure_devops_proj" {
  description = "Azure DevOps project for bootstrap repository"
  type        = string
  default     = "null"
}

variable "github_org" {
  description = "Org of GitHub repositories"
  type        = string
  default     = "null"
}

variable "github_app_id" {
  description = "ID of GitHub Application used by Git Auth Proxy"
  type        = number
  default     = "null"
}

variable "github_installation_id" {
  description = "Installation ID of GitHub Application used by Git Auth Proxy"
  type        = number
  default     = "null"
}

variable "github_private_key" {
  description = "Private Key for GitHub Application used by Git Auth Proxy"
  type        = string
  default     = "null"
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add initial config
}

variable "credentials" {
  description = "List of credentials for Git Providers."
  type = list(object({
    type = string # azuredevops or github
    azure_devops = object({
      org  = string
      pat  = string
=======
>>>>>>> make fmt & docs
    })
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
  }))
}

variable "fleet_infra" {
  description = "Configuration for Flux bootstrap repository."
  type = object({
    type = string
    org  = string
    proj = string
    repo = string
  })
=======
>>>>>>> fe36c7a... Add initial config
}

variable "credentials" {
  description = "List of credentials for Git Providers."
  type = list(object({
    type = string # azuredevops or github
    azure_devops = object({
      org  = string
      pat  = string
=======
>>>>>>> a69675f... make fmt & docs
    })
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
  }))
}

variable "fleet_infra" {
  description = "Configuration for Flux bootstrap repository."
  type = object({
    type = string
    org  = string
    proj = string
    repo = string
  })
=======
>>>>>>> d074599... Add initial config
}

variable "credentials" {
  description = "List of credentials for Git Providers."
  type = list(object({
    type = string # azuredevops or github
    azure_devops = object({
      org  = string
      pat  = string
=======
>>>>>>> f8311b7... make fmt & docs
    })
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
  }))
}

variable "fleet_infra" {
  description = "Configuration for Flux bootstrap repository."
  type = object({
    type = string
    org  = string
    proj = string
    repo = string
  })
=======
>>>>>>> Add initial config
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      name        = string
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
}
=======
      name = string
=======
      name        = string
>>>>>>> make fmt & docs
=======
      name        = string
>>>>>>> a69675f... make fmt & docs
=======
      name        = string
>>>>>>> f8311b7... make fmt & docs
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
<<<<<<< HEAD
=======
      name = string
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
<<<<<<< HEAD
>>>>>>> fe36c7a... Add initial config
=======
      name = string
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
<<<<<<< HEAD
>>>>>>> d074599... Add initial config
=======
      name = string
      flux = object({
        enabled     = bool
        create_crds = bool
        org         = string
        proj        = string
        repo        = string
      })
    })
  )
>>>>>>> Add initial config
}

variable "cluster_repo" {
  description = "Name of cluster repository"
  type        = string
  default     = "fleet-infra"
}

variable "branch" {
  description = "Branch to point source controller towards"
  type        = string
  default     = "main"
}
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add initial config
=======
}
>>>>>>> Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> fe36c7a... Add initial config
=======
}
>>>>>>> 115a386... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> d074599... Add initial config
=======
}
>>>>>>> dfd9823... Initial change of config to use one module - fluxcd-v2
=======
>>>>>>> Add initial config
