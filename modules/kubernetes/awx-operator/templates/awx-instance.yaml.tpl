apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: ${instance_name}
  namespace: awx
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  service_type: ${service_type}
%{ if ingress_type != "" ~}
  ingress_type: ${ingress_type}
%{ endif ~}
%{ if hostname != "" ~}
  hostname: ${hostname}
%{ endif ~}
  postgres_storage_class: managed-csi
  projects_persistence: true
  projects_storage_class: managed-csi
  projects_storage_size: 8Gi
