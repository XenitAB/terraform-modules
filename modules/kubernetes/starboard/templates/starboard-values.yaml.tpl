# targetNamespace defines where you want starboard-operator to operate. By
# default it will only operate in the namespace its installed in, but you can
# specify another namespace, or a comma separated list of namespaces, or set it
# to a blank string to let it operate in all namespaces.
targetNamespaces: ""

trivy:
  # mode is the Trivy client mode. Either Standalone or ClientServer. Depending
  # on the active mode other settings might be applicable or required.
  mode: ClientServer
  severity: MEDIUM,HIGH,CRITICAL
  ignoreUnfixed: true
  serverURL: "http://trivy.trivy.svc.cluster.local:4954"
  # The trivy image have to match with the trivy server
  imageRef: docker.io/aquasec/trivy:0.23.0


# TODO insert logic for AWS IAM ECR access config
# https://aquasecurity.github.io/starboard/v0.12.0/integrations/managed-registries/

operator:
  # configAuditScannerEnabled the flag to enable configuration audit scanner
  configAuditScannerEnabled: false
  # kubernetesBenchmarkEnabled the flag to enable CIS Kubernetes Benchmark scanner
  kubernetesBenchmarkEnabled: false
  # vulnerabilityScannerScanOnlyCurrentRevisions the flag to only create vulnerability scans on the current revision of a deployment.
  vulnerabilityScannerScanOnlyCurrentRevisions: true
  # vulnerabilityScannerReportTTL the flag to set how long a vulnerability report should exist. "" means that the vulnerabilityScannerReportTTL feature is disabled
  vulnerabilityScannerReportTTL: "25h"

%{~ if provider == "aws" ~}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
%{~ endif ~}
