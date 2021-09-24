# targetNamespace defines where you want starboard-operator to operate. By
# default it will only operate in the namespace its installed in, but you can
# specify another namespace, or a comma separated list of namespaces, or set it
# to a blank string to let it operate in all namespaces.
targetNamespaces: ""

trivy:
  # mode is the Trivy client mode. Either Standalone or ClientServer. Depending
  # on the active mode other settings might be applicable or required.
  mode: ClientServer
  severity: CRITICAL
  ignoreUnfixed: true
  serverURL: "http://trivy.trivy.svc.cluster.local:4954"

# TODO insert logic for AWS IAM ECR access config
# https://aquasecurity.github.io/starboard/v0.12.0/integrations/managed-registries/
