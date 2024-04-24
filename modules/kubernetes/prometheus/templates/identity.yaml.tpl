apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: prometheus
  namespace: prometheus
spec:
  type: 0
  resourceID: ${azure_config.identity.resource_id}
  clientID: ${azure_config.identity.client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: prometheus
  namespace: prometheus
spec:
  azureIdentity: prometheus
  selector: prometheus
---