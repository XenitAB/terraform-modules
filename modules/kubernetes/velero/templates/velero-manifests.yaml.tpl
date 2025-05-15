apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: daily-full-backups
  namespace: velero
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
  namespace: velero
  labels:
    frequency: hourly
    full: "false"
spec:
  schedule: "15 */1 * * *"
  template:
    snapshotVolumes: false
    ttl: 96h0m0s

