trivy:
  labels:
    aadpodidbinding: trivy

persistence:
  storageClass: ${volume_claim_storage_class_name}
