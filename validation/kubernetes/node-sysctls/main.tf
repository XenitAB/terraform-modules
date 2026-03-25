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
      profile_name = "elasticsearch"
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
      profile_name = "gpu-llm" # example profile name, could be `gpu-llm` or `gpu-ai` or something else, but this is just an example of the possibilities
      sysctls = {
        "kernel.numa_balancing" = "0" # example setting to handle numa balancing for GPU workloads, could be "1" as well depending on the workload requirements, but this is just an example of the possibilities
        "vm.swappiness"         = "0" # example setting to minimize swapping for GPU workloads, could be "1" as well depending on the workload requirements, but this is just an example of the possibilities
      }
      node_selector = {
        "accelerator" = "nvidia" # could be `"workload" = "gpu-llm"´ as well, but this is just an example of the possibilities
      }
      tolerations = [
        {
          key      = "nvidia.com/gpu" # could be `key = "workload"´ and `value = "gpu-llm"´ as well, but this is just an example of the possibilities
          operator = "Exists"         # should be "Equal" normally to match architectural pattern (value not removed), but this is just an example of the possibilities
          effect   = "NoSchedule"     # should be "NoSchedule" normally to match architectural pattern (value not removed & pod have matching toleration), but this is just an example of the possibilities
        }
      ]
    },
    {
      profile_name = "gpu-hpc"
      sysctls = {
        "kernel.numa_balancing" = "0"
        "vm.zone_reclaim_mode"  = "0"
        "vm.swappiness"         = "1"
      }
      node_selector = {
        "workload" = "gpu-hpc"
      }
      tolerations = [
        {
          key      = "workload"
          operator = "Equal"
          value    = "gpu-hpc"
          effect   = "NoSchedule"
        }
      ]
    },
    {
      profile_name = "cpu-hpc"
      sysctls = {
        "kernel.numa_balancing"          = "0"
        "kernel.sched_migration_cost_ns" = "5000000"
        "kernel.sched_autogroup_enabled" = "0"
        "vm.zone_reclaim_mode"           = "0"
        "vm.swappiness"                  = "1"
        "vm.dirty_ratio"                 = "10"
        "vm.dirty_background_ratio"      = "5"
        "fs.file-max"                    = "2097152"
        "net.core.rmem_max"              = "134217728"
        "net.core.wmem_max"              = "134217728"
        "net.core.netdev_max_backlog"    = "250000"
        "net.ipv4.tcp_rmem"              = "4096 87380 134217728"
        "net.ipv4.tcp_wmem"              = "4096 65536 134217728"
      }
      node_selector = {
        "workload" = "cpu-hpc"
      }
      tolerations = [
        {
          key      = "workload"
          operator = "Equal"
          value    = "cpu-hpc"
          effect   = "NoSchedule"
        }
      ]
    },
    {
      profile_name = "network-intensive"
      sysctls = {
        "net.core.somaxconn"           = "65535"
        "net.ipv4.tcp_max_syn_backlog" = "65535"
        "net.core.netdev_max_backlog"  = "65535"
      }
    },
  ]
}