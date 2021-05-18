# Priority classes allows pods to be scheduled before other pods and evict pods from nodes.
# There are two types of priority classes, platform and tenant. All platform priority classes
# should have a higher priority value than the tenant priority classes. The platform-high
# class is not set to the maximum value on purpose, as to leave space to create even more
# prioritized classes in the future. It is preferred to use these classes rather than
# system-cluster-critical and system-node-critical as they are used by AKS critical pods
# which should have higher priority.

# TODO (Philip): Set preemptionPolicy when availible in the kubernetes provider.

# Platform

resource "kubernetes_priority_class" "platform_high" {
  metadata {
    name = "platform-high"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }

  description = "Used by DaemonSets that need to always schedule on every node. Ex. node-exporter, promtail, aad-pod-identity-nmi."
  value = 900002
}

resource "kubernetes_priority_class" "platform_medium" {
  metadata {
    name = "platform-medium"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }

  description = "Used by less critical pods that still need premeption. Ex. Thanos Receiver, Nginx Ingress."
  value = 900001
}

resource "kubernetes_priority_class" "platform_low" {
  metadata {
    name = "platform-low"
    labels = {
      "xkf.xenit.io/kind" = "platform"
    }
  }

  description = "Should be default for all other platform pods."
  value = 900000
}

# Tenant

resource "kubernetes_priority_class" "tenant_high" {
  metadata {
    name = "tenant-high"
    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  description = "Used by tenant critical applications that should needs to run."
  value = 800002
}

resource "kubernetes_priority_class" "tenant_medium" {
  metadata {
    name = "tenant-medium"
    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  description = "Used by less critical tenant applications that still need priority."
  value = 800001
}

resource "kubernetes_priority_class" "tenant_low" {
  metadata {
    name = "tenant-low"
    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  description = "Good default for most tenant pods."
  value = 800000
}
