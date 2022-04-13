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
          tenant: "${tenant_id}"
          environment: "${environment}"
          cluster: "${cluster_name}"

    extraRelabelConfigs:
      - action: drop
        regex: ingress-nginx
        source_labels:
          - __meta_kubernetes_namespace
      %{~ for namespace in excluded_namespaces ~}
      - action: drop
        regex: ${namespace}
        source_labels:
          - __meta_kubernetes_namespace
      %{~ endfor ~}

priorityClassName: "platform-high"

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

    