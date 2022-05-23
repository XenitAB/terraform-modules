config:
  lokiAddress: "${loki_address}"
  snippets:
    extraClientConfigs: |
      tls_config:
        cert_file: /mnt/tls/tls.crt
        key_file: /mnt/tls/tls.key
    
    pipelineStages:
      - cri: {}
      - static_labels:
          tenant_id: "${tenant_id}"
          environment: "${environment}"
          cluster: "${cluster_name}"
      
      # Drop 2xx and 3xx from ingress-nginx since it it generates a lot of log messages. Example:
      # xxx.xxx.xxx.xxx - - [04/May/2022:13:12:50 +0000] "POST /api/v1/receive HTTP/2.0" 200 0 "-" "Prometheus/2.35.0" 
      # 35234 0.004 [monitor-router-receiver-remote-write] [] 10.244.34.149:19291 0 0.004 200 0156a072a34b23dc09bcfcfe87991c7b
      - match:
          selector: '{namespace="ingress-nginx"}'
          stages:
          - regex:
              expression: '^(?P<_>[\w\.]+) - (?P<_>[^ ]*) \[(?P<_>.*)\] "(?P<_>[^ ]*) (?P<_>[^ ]*) (?P<_>[^ ]*)" (?P<nginx_status>[\d]+).*'
      - drop:
          source: nginx_status
          expression: "[2-3][0-9][0-9]"
          drop_counter_reason: nginx_ok

    extraRelabelConfigs:
      %{~ for namespace in excluded_namespaces ~}
      - action: drop
        regex: ${namespace}
        source_labels:
          - __meta_kubernetes_namespace
      %{~ endfor ~}

priorityClassName: "platform-high"

# Tolerate everything
tolerations:
  - operator: Exists
    effect: NoSchedule

resources:
  limits:
    memory: 200Mi
  requests:
    cpu: 50m
    memory: 100Mi
 
%{~ if provider == "azure" ~}
podLabels:
  aadpodidbinding: promtail
%{~ endif ~}

extraVolumes:
  - name: secrets-store
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: promtail
  - name: tls
    secret:
      secretName: "${k8s_secret_name}"  

extraVolumeMounts:
  - name: secrets-store
    mountPath: /mnt/secrets-store
  - name: tls
    mountPath: "/mnt/tls"
    readOnly: true

%{~ if provider == "aws" ~}
serviceAccount:
  annotations:
     "eks.amazonaws.com/role-arn": "${aws_config.role_arn}"
%{~ endif ~}

extraObjects: 
  %{~ if provider == "aws" ~}
  - apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
    kind: SecretProviderClass
    metadata:
      name: promtail
    spec:
      provider: "aws"
      parameters:
        objects: |
          - objectName: "${aws_config.key_parameter_name}"
            objectType: "ssmparameter"
          - objectName: "${aws_config.crt_parameter_name}"
            objectType: "ssmparameter"
      secretObjects:
        - secretName: "${k8s_secret_name}"
          type: kubernetes.io/tls
          data:
            - objectName: "${aws_config.key_parameter_name}"
              key: tls.key
            - objectName: "${aws_config.crt_parameter_name}"
              key: tls.crt
  %{~ endif ~}
  %{~ if provider == "azure" ~}
  - apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
    kind: SecretProviderClass
    metadata:
      name: promtail
    spec:
      provider: "azure"
      parameters:
        usePodIdentity: "true"
        keyvaultName: "${azure_config.azure_key_vault_name}"
        objects:  |
          array:
            - |
              objectName: "${azure_config.keyvault_secret_name}"
              objectType: secret
        tenantId: "${azure_config.identity.tenant_id}"
      secretObjects:
        - secretName: "${k8s_secret_name}"
          type: kubernetes.io/tls
          data:
            - objectName: "${azure_config.keyvault_secret_name}"
              key: tls.key
            - objectName: "${azure_config.keyvault_secret_name}"
              key: tls.crt

  - apiVersion: aadpodidentity.k8s.io/v1
    kind: AzureIdentity
    metadata:
      name: promtail
    spec:
      type: 0
      resourceID: "${azure_config.identity.resource_id}"
      clientID: "${azure_config.identity.client_id}"

  - apiVersion: aadpodidentity.k8s.io/v1
    kind: AzureIdentityBinding
    metadata:
      name: promtail
    spec:
      azureIdentity: promtail
      selector: promtail
  %{~ endif ~}

  - apiVersion: v1
    kind: Service
    metadata:
      name: promtail-metrics
      namespace: "${namespace}"
      labels:
        app.kubernetes.io/instance: promtail
        app.kubernetes.io/name: promtail
    spec:
      clusterIP: None
      ports:
        - name: http-metrics
          port: 3101
          targetPort: http-metrics
          protocol: TCP
      selector:
        app.kubernetes.io/instance: promtail
        app.kubernetes.io/name: promtail

    