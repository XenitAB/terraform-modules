terraform {
  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.4"
    }
  }
}

provider "git" {}

module "node_sysctls" {
  source = "../../../modules/kubernetes/node-sysctls"

  cluster_id  = "foobar"
  environment = "dev"
  tenant_name = "foo"

  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }

  node_sysctls_config = [
    {
      name = "elasticsearch"
      sysctls = {
        "vm.max_map_count" = "262144"
      }
      node_selector = {
        "workload" = "elasticsearch"
      }
      tolerations = [
        {
          key      = "workload"
          operator = "Equal"
          value    = "elasticsearch"
          effect   = "NoSchedule"
        }
      ]
    },
    {
      name = "gpu"
      sysctls = {
        "kernel.numa_balancing" = "0"
        "vm.swappiness"        = "0"
      }
      node_selector = {
        "accelerator" = "nvidia"
      }
      tolerations = [
        {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      ]
    },
    {
      name = "network-intensive"
      sysctls = {
        "net.core.somaxconn"           = "65535"
        "net.ipv4.tcp_max_syn_backlog" = "65535"
        "net.core.netdev_max_backlog"  = "65535"
      }
    },
  ]
}