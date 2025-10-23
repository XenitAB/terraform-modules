apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: trivy-operator
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: trivy
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://aquasecurity.github.io/helm-charts
    targetRevision: 0.31.0
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
        podAnnotations:
          azure.workload.identity/client-id: ${client_id}
        operator:
          podLabels: {
            azure.workload.identity/use: "true"
          }
          
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

          # Metrics
          metricsVulnIdEnabled: false
          # Additional metrics settings
          metricsExposedSecretInfo: false
          metricsConfigAuditInfo: false
          metricsRbacAssessmentInfo: false
          metricsInfraAssessmentInfo: false
          metricsImageInfo: false
          metricsClusterComplianceInfo: false

        trivyOperator:
          # scanJobPodTemplateLabels comma-separated representation of the labels which the user wants the scanner pods to be
          # labeled with. Example: `foo=bar,env=stage` will labeled the scanner pods with the labels `foo: bar` and `env: stage`
          scanJobPodTemplateLabels: azure.workload.identity/use=true
          scanJobAnnotations: "azure.workload.identity/client-id=${client_id}"
          scanJobServiceAccountName: trivy-operator
        resources:
          requests:
            cpu: 15m
            memory: 200Mi
        serviceAccount:
          create: true
          name: trivy-operator
          annotations:
            azure.workload.identity/client-id: ${client_id}
