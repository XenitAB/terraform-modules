replicas: ${replica_count}
controller:
    env:
    - name: FEATURE_GATES
      value: Drift=true
    - name: LEADER_ELECT 
      value: "false"
    - name: CLUSTER_NAME
      value: ${cluster_name}
    - name: CLUSTER_ENDPOINT
      value: ${cluster_endpoint}
    - name: SSH_PUBLIC_KEY
      value: "${ssh_public_key}" 
    - name: NETWORK_PLUGIN
      value: "azure"
    - name: NETWORK_PLUGIN_MODE
      value: "overlay"
    - name: NETWORK_DATAPLANE
      value: "cilium"
    - name: NETWORK_POLICY
      value: ""
    - name: NODE_IDENTITIES
      value: "${node_identities}"
    - name: VNET_SUBNET_ID
      value: "${vnet_subnet_id}"
    - name: ARM_SUBSCRIPTION_ID
      value: ${subscription_id}
    - name: LOCATION
      value: ${location}
    - name: ARM_USE_CREDENTIAL_FROM_ENVIRONMENT
      value: "true"
    - name: ARM_USE_MANAGED_IDENTITY_EXTENSION
      value: "false"
    - name: ARM_USER_ASSIGNED_IDENTITY_ID
      value: ""
    - name: AZURE_NODE_RESOURCE_GROUP
      value: ${node_resource_group_name}
    envFrom:
      - secretRef:
          name: kubelet-bootstrap-token
    settings:
      batchMaxDuration: ${batch_max_duration}
      batchIdleDuration: ${batch_idle_duration}
serviceAccount:
    name: karpenter-sa
    annotations:
      azure.workload.identity/client-id: ${client_id}
podLabels:
    azure.workload.identity/use: "true"
%{~ if replica_count < default_node_pool_size ~}
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: karpenter.sh/nodepool
              operator: DoesNotExist
%{~ endif ~}