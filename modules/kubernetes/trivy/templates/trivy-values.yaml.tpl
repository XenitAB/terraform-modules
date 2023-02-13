trivy:
  %{~ if provider == "aws" ~}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: ${trivy_role_arn}
  %{~ endif ~}
  %{~ if provider == "azure" ~}
  labels:
    aadpodidbinding: trivy
  %{~ endif ~}

persistence:
  storageClass: ${volume_claim_storage_class_name}
