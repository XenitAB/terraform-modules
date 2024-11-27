# Specific for this module
installNamespace: false
namespace: "linkerd"
cniEnabled: false
identity:
  issuer:
    scheme: kubernetes.io/tls

identityTrustAnchorsPEM: |
  ${linkerd_trust_anchor_pem}

priorityClassName: platform-high

proxyInjector:
  namespaceSelector:
    matchExpressions:
    - key: control-plane
      operator: NotIn
      values:
      - "true"
  externalSecret: true
  caBundle: |
    ${webhook_issuer_pem}

profileValidator:
  namespaceSelector:
    matchExpressions:
    - key: control-plane
      operator: NotIn
      values:
      - "true"
  externalSecret: true
  caBundle: |
    ${webhook_issuer_pem}


#
# The below is taken from: https://github.com/linkerd/linkerd2/blob/main/charts/linkerd2/values-ha.yaml
#

enablePodAntiAffinity: true

# proxy configuration
proxy:
  image:
    name: ghcr.io/linkerd/proxy
  # A better default for log collectors that require structured data
  logFormat: json
  resources:
    cpu:
      request: 100m
    memory:
      limit: 250Mi
      request: 20Mi

# controller configuration
controllerImage: ghcr.io/linkerd/controller
controllerReplicas: 3
controllerResources: &controller_resources
  cpu: &controller_resources_cpu
    limit: ""
    request: 100m
  memory:
    limit: 250Mi
    request: 50Mi
destinationResources: *controller_resources

# identity configuration
identityResources:
  cpu: *controller_resources_cpu
  memory:
    limit: 250Mi
    request: 10Mi

# heartbeat configuration
heartbeatResources: *controller_resources

# proxy injector configuration
proxyInjectorResources: *controller_resources
webhookFailurePolicy: Fail

# service profile validator configuration
spValidatorResources: *controller_resources

policyController:
  image:
    name: ghcr.io/linkerd/policy-controller
debugContainer:
  image:
    name: ghcr.io/linkerd/debug
proxyInit:
  image:
    name: ghcr.io/linkerd/proxy-init
