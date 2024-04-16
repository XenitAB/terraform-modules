apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: daily-full-backups
  labels:
    frequency: daily
    full: "true"
spec:
  schedule: "0 2 * * *"
  template:
    ttl: 960h0m0s
---
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: hourly-minimal-backups
  labels:
    frequency: hourly
    full: "false"
spec:
  schedule: "15 */1 * * *"
  template:
    snapshotVolumes: false
    ttl: 960h0m0s
---
%{ if resource_id != "" && client_id != "" ~}
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: velero
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: velero
spec:
  azureIdentity: velero
  selector: velero
%{ endif }
