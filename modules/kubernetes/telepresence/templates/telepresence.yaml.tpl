apiVersion: v1
kind: Namespace
metadata:
 name: ambassador
 labels:
   name              = "telepresence"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: telepresence
  namespace: ambassador
spec:
  interval: 1m0s
  url: "https://app.getambassador.io"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: telepresence
  namespace: ambassador
spec:
  chart:
    spec:
      chart: telepresence
      sourceRef:
        kind: HelmRepository
        name: telepresence
      version: v2.18.1
  interval: 1m0s
  values:
    client:
      %{ if telepresence_config.allow_conflicting_subnets != [] ~}
      allowConflictingSubnets: 
      %{ for subnet in telepresence_config.allow_conflicting_subnets ~}
      - ${subnet}
      %{ endfor }
      %{ endif }
      connectionTTL: 12h
    clientRbac:
      create: ${ telepresence_config.client_rbac.create }
      %{ if telepresence_config.client_rbac.subjects ~}
      subjects:
      %{ for subject in telepresence_config.client_rbac.namespaces ~}
      - ${subject}
      %{ endfor }
      %{ endif }
      namespaced: ${ telepresence_config.client_rbac.namespaced }
       %{ if telepresence_config.client_rbac.namespaces ~}
      namespaces:
      - ambassador
      %{ for ns in telepresence_config.client_rbac.namespaces ~}
      - ${ns}
      %{ endfor }
      %{ endif }
    managerRbac:
      create: ${ telepresence_config.manager_rbac.create }
      namespaced: ${ telepresence_config.manager_rbac.namespaced }
       %{ if telepresence_config.manager_rbac.namespaces ~}
      namespaces:
      - ambassador
      %{ for ns in telepresence_config.manager_rbac.namespaces ~}
      - ${ns}
      %{ endfor }
      %{ endif }
