trivy:
  %{~ if provider == "aws" ~}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: ${trivy_role_arn}
  %{~ endif ~}
