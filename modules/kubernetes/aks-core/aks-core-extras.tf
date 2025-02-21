# Priority classes allows pods to be scheduled before other pods and evict pods from nodes.
# There are two types of priority classes, platform and tenant. All platform priority classes
# should have a higher priority value than the tenant priority classes. The platform-high
# class is not set to the maximum value on purpose, as to leave space to create even more
# prioritized classes in the future. It is preferred to use these classes rather than
# system-cluster-critical and system-node-critical as they are used by AKS critical pods
# which should have higher priority.
#
# Hot tip if you want to list all pods and their priority class in a cluster.
# `kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,PRIORITY:.spec.priorityClassName`

resource "helm_release" "aks_core_extras" {
  chart       = "${path.module}/charts/aks-core-extras"
  name        = "aks-core-extras-extras"
  namespace   = "default"
  max_history = 3

  set {
      name  = "spotInstancesHack.enabled"
      value = var.spot_instances_hack_enabled
  }
}
