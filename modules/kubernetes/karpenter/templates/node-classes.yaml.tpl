apiVersion: karpenter.azure.com/v1alpha2
kind: AKSNodeClass
metadata:
  name: ${class.name}
  annotations:
    kubernetes.io/description: "General purpose AKSNodeClass for running Ubuntu2204 nodes"
spec:
  imageFamily: ${class.image_family}
  kubelet:
    containerLogMaxSize: ${class.kubelet.container_log_max_size}
    cpuCFSQuota: ${class.kubelet.cpu_cfs_quota}
    cpuCFSQuotaPeriod: ${class.kubelet.cpu_cfs_quota_period}
    cpuManagerPolicy: ${class.kubelet.cpu_manager_policy}
    topologyManagerPolicy: ${class.kubelet.topology_manager_policy}