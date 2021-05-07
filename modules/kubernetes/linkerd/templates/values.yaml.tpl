# Specific for this module
installNamespace: false
namespace: "linkerd"
cniEnabled: true
identity:
  issuer:
    scheme: kubernetes.io/tls

identityTrustAnchorsPEM: |
  ${linkerd_trust_anchor_pem}

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
  resources:
    cpu:
      request: 100m
    memory:
      limit: 250Mi
      request: 20Mi

# controller configuration
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