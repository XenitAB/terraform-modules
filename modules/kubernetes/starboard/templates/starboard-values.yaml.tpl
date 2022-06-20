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
  serverURL: "http://trivy.starboard-operator.svc.cluster.local:4954"
  imageRef: docker.io/aquasec/trivy:0.24.3

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
    eks.amazonaws.com/role-arn: ${starboard_role_arn}
%{~ endif ~}

%{~ if provider == "azure" ~}
starboard:
  # scanJobPodTemplateLabels comma-separated representation of the labels which the user wants the scanner pods to be
  # labeled with. Example: `foo=bar,env=stage` will labeled the scanner pods with the labels `foo: bar` and `env: stage`
  scanJobPodTemplateLabels: "aadpodidbinding=trivy"
%{~ endif ~}

resources: {}
  requests:
    cpu: 15m
    memory: 200Mi
