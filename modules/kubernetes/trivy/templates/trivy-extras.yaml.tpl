%{ if resource_id != "" && client_id != "" ~}
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: trivy
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: trivy
spec:
  azureIdentity: trivy
  selector: trivy
%{ endif }