apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: trivy-operator
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: trivy
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://aquasecurity.github.io/helm-charts
    targetRevision: 0.25.0
    chart: trivy-operator
    helm:
      valuesObject:
        # targetNamespace defines where you want trivy-operator to operate. By
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
        operator:
          # configAuditScannerEnabled the flag to enable configuration audit scanner
          configAuditScannerEnabled: false
          # vulnerabilityScannerScanOnlyCurrentRevisions the flag to only create vulnerability scans on the current revision of a deployment.
          vulnerabilityScannerScanOnlyCurrentRevisions: true
          # rbacAssessmentScannerEnabled the flag to enable rbac assessment scanner
          rbacAssessmentScannerEnabled: false
          # infraAssessmentScannerEnabled the flag to enable infra assessment scanner
          infraAssessmentScannerEnabled: false
          # scannerReportTTL the flag to set how long a report should exist. "" means that the ScannerReportTTL feature is disabled
          ScannerReportTTL: "25h"
        trivyOperator:
          # scanJobPodTemplateLabels comma-separated representation of the labels which the user wants the scanner pods to be
          # labeled with. Example: `foo=bar,env=stage` will labeled the scanner pods with the labels `foo: bar` and `env: stage`
          scanJobPodTemplateLabels: azure.workload.identity/use=true
        resources:
          requests:
            cpu: 15m
            memory: 200Mi
        serviceAccount:
          create: true
          name: trivy-operator
          annotations:
            azure.workload.identity/client-id: ${client_id}
