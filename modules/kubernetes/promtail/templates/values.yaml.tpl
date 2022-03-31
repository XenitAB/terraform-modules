config:
  lokiAddress: "${loki_address}"

  %{~ if provider == "azure" ~}
podLabels:
  aadpodidbinding: promtail
  %{~ endif ~}


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
      labels:
        {{- include "promtail.labels" . | nindent 4 }}
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
