# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Calendar Versioning](https://calver.org/).

## Unreleased

### Changed

- [#565](https://github.com/XenitAB/terraform-modules/pull/565) [Breaking] Update Ingress Nginx major version.

### Fixed

- [#570](https://github.com/XenitAB/terraform-modules/pull/570) Only add network policy for Datadog / Grafana-Agent if default deny is true

## 2022.02.4

### Added

- [#541](https://github.com/XenitAB/terraform-modules/pull/541) add support to enable private endpoints on subnets
- [#549](https://github.com/XenitAB/terraform-modules/pull/549) Add resource requests & limits for goldilocks.
- [#548](https://github.com/XenitAB/terraform-modules/pull/548) Enable grafana-agent in Prometheus.
- [#558](https://github.com/XenitAB/terraform-modules/pull/558) Add ClusterRole `kubectl get nodes` to tenants.
- [#560](https://github.com/XenitAB/terraform-modules/pull/560) Add SecretProviderClass CRD to ClusterRole `custom_resource_edit`.
- [#563](https://github.com/XenitAB/terraform-modules/pull/563) Upgrade azurerm provider in aks to 2.97.0

### Changed

- [#553](https://github.com/XenitAB/terraform-modules/pull/553) Remove Secrets and ConfigMaps from collected Kube State Metrics resources.

### Fixed

- [#551](https://github.com/XenitAB/terraform-modules/pull/551) Fix pod label selector for Prometheus monitor.

## 2022.02.3

### Added

- [#542](https://github.com/XenitAB/terraform-modules/pull/542) Add node local DNS to resolve throughput issues related to slow DNS queries.

### Fixed

- [#545](https://github.com/XenitAB/terraform-modules/pull/545) Set prometheus disk size to 10Gi.

## 2022.02.2

### Added

- [#543](https://github.com/XenitAB/terraform-modules/pull/543) [Breaking] Allow setting os_disk_type on kubernetes node pools. We recommend setting Ephemeral.

### Fixed

- [#540](https://github.com/XenitAB/terraform-modules/pull/540) Add podAntiAffinity to Ingress-nginx.

## 2022.02.1

### Added

- [#522](https://github.com/XenitAB/terraform-modules/pull/522) Add networkpolicy for datadog and grafana-agent to tenant namespace.

### Changed

- [#524](https://github.com/XenitAB/terraform-modules/pull/524) Update grafana-agent to 0.1.5
- [#531](https://github.com/XenitAB/terraform-modules/pull/531) Make prefix configurable for Azure role definition names
- [#533](https://github.com/XenitAB/terraform-modules/pull/533) Update cert manager version to 1.6.1
- [#535](https://github.com/XenitAB/terraform-modules/pull/535) Azad-kube-proxy define resources
- [#536](https://github.com/XenitAB/terraform-modules/pull/536) Update OPA Gatekeeper Helm charts

### Fixed

- [#532](https://github.com/XenitAB/terraform-modules/pull/532) [Breaking] Fix bug in route table association (does **not** affect XKF by default)
- [#527](https://github.com/XenitAB/terraform-modules/pull/527) Add kubernetes resource definitions for grafana-agent-operator.

## 2022.01.4

### Changed

- [#523](https://github.com/XenitAB/terraform-modules/pull/523) Update starboard to 0.14.0, only scan the latest deployments
  and set a TTL on the vulnerability reports to be recreated after 25 hours.

### Added

- [#513](https://github.com/XenitAB/terraform-modules/pull/513) EKS opinionated module `eks-core` added.

## 2022.01.3

### Changed

- [#517](https://github.com/XenitAB/terraform-modules/pull/517) Change VPA storage from prometheus to checkpoint.

### Fixed

- [#519](https://github.com/XenitAB/terraform-modules/pull/519) Fix nginx ingress service monitor selector when running multiple controllers.

## 2022.01.2

### Added

- [#506](https://github.com/XenitAB/terraform-modules/pull/506) Add VPA (Vertical Pod Autoscaling) as a module.

### Changed

- [#510](https://github.com/XenitAB/terraform-modules/pull/510) [Breaking] Run prometheus in agent mode and update kube-prometheus-stack to v30.0.0.
- [#514](https://github.com/XenitAB/terraform-modules/pull/514) Starboard enable scanning of MEDIUM,HIGH,CRITICAL severity CVE:s
  and disable configAuditScannerEnabled and kubernetesBenchmarkEnabled.

## 2022.01.1

### Added

- [#504](https://github.com/XenitAB/terraform-modules/pull/504) Give developers access to starboard report.

### Changed

- [#487](https://github.com/XenitAB/terraform-modules/pull/487) Update external-dns Helm chart.
- [#492](https://github.com/XenitAB/terraform-modules/pull/492) Increase scrape interval starboard-exporter metric.

## 2021.12.6

### Changed

- [#502](https://github.com/XenitAB/terraform-modules/pull/502) Add externalLabels to logs for Grafana Agent

## 2021.12.5

### Changed

- [#497](https://github.com/XenitAB/terraform-modules/pull/497) Remove namespaces config option for kube-state-metrics.
- [#498](https://github.com/XenitAB/terraform-modules/pull/498) Set AKS cluster autoscaler expander strategy to least waste.

## 2021.12.4

### Added

- [#491](https://github.com/XenitAB/terraform-modules/pull/491) Add Grafana Agent for observability with Grafana Cloud

### Changed

- [#486](https://github.com/XenitAB/terraform-modules/pull/486) Enable the option to create AKS node pools backed by spot instances.
- [#481](https://github.com/XenitAB/terraform-modules/pull/481) Use upstream starboard exporter.

## 2021.12.3

### Changed

- [#482](https://github.com/XenitAB/terraform-modules/pull/482) add support for non VirtualAppliance routes

## 2021.12.2

### Fixed

- [#478](https://github.com/XenitAB/terraform-modules/pull/478) Only set annotation blocklist when allow annotation is false.

## 2021.12.1

### Changed

- [#470](https://github.com/XenitAB/terraform-modules/pull/470) Set max history for Helm releases to reduce the amount of secrets created.
- [#471](https://github.com/XenitAB/terraform-modules/pull/471) Update azad-kube-proxy from v0.0.27 to v0.0.30 and remove dashboard (k8dash/skooner).
- [#472](https://github.com/XenitAB/terraform-modules/pull/472) [Breaking] Update ingress-nginx to 3.40.0 and disable allow-snippet-annotations by default.
  Add [annotation-value-word-blocklist](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#annotation-value-word-blocklist).

### Added

- [#463](https://github.com/XenitAB/terraform-modules/pull/463) Add azure-metrics to monitor azure specific metrics.
- [#473](https://github.com/XenitAB/terraform-modules/pull/473) Add starboard-exporter to gather trivy metrics from starboard CRD:s.

### Removed

- [#469](https://github.com/XenitAB/terraform-modules/pull/469) Remove deprecated modules azure/governance, kubernetes/external-secrets, and kubernetes/kyverno.

### Fixed

- [#474](https://github.com/XenitAB/terraform-modules/pull/474) Adjust prometheus resource requests to fix OOM Kill.
- [#475](https://github.com/XenitAB/terraform-modules/pull/475) Fix multi doc separator in prometheus monitors.
- [#476](https://github.com/XenitAB/terraform-modules/pull/476) Remove extra separator in prometheus monitors.

## 2021.11.7

### Added

- [#437](https://github.com/XenitAB/terraform-modules/pull/437) Add podmonitor for secrets-store-csi-driver

### Changed

- [#465](https://github.com/XenitAB/terraform-modules/pull/465) [Breaking] Move xenit credentials to Prometheus and remove Xenit proxy.

### Fixed

- [#466](https://github.com/XenitAB/terraform-modules/pull/466) Replace misspelled variable kube_state_metrics_namepsaces with kube_state_metrics_namespaces

## 2021.11.6

### Added

- [#453](https://github.com/XenitAB/terraform-modules/pull/453) Add role for kubectl top pod

### Fixed

- [#461](https://github.com/XenitAB/terraform-modules/pull/461) Set resource request for Prometheus and update remote write config.
- [#460](https://github.com/XenitAB/terraform-modules/pull/460) Increase gatekeeper-audit memory request.

### Deprecated

- [#456](https://github.com/XenitAB/terraform-modules/pull/456) Deprecate goldpinger and remove it from aks-core and eks-core.

## 2021.11.5

### Fixed

- [#459](https://github.com/XenitAB/terraform-modules/pull/459) Decrease Prometheus remote write max shards to reduce concurrent requests.

## 2021.11.4

### Fixed

- [#457](https://github.com/XenitAB/terraform-modules/pull/457) Increase Prometheus remote write max back off to mitigate DDOS.

## 2021.11.3

### Changed

- [#454](https://github.com/XenitAB/terraform-modules/pull/454) Set prometheus remote write queue config, lowering default max shards and increasing default min back off.

### Fixed

- [#451](https://github.com/XenitAB/terraform-modules/pull/451) Set revision history for all certificates to limit the amount of certificate requests.

## 2021.11.2

### Changed

- [#448](https://github.com/XenitAB/terraform-modules/pull/448) [Breaking] Define namespaces that kube-state-metrics should gather metrics from.
  This is a **breaking change** and will cause users that don't include all namespaces they want metrics from
  in `kube_state_metrics_namepsaces_extras` to loose metrics.
  The default values are set in aks-core/eks-core so they are adjusted to our current platform namespaces.
  We hope this way of working can be improved in [future kube-state-metrics releases](https://github.com/kubernetes/kube-state-metrics/issues/1631)

### Fixed

- [#445](https://github.com/XenitAB/terraform-modules/pull/445) Re-enable resource limit ranges in EKS.
- [#441](https://github.com/XenitAB/terraform-modules/pull/441) Fix dependancy between tenant namespaces and resources in namespace.

## 2021.11.1

### Changed

- [#432](https://github.com/XenitAB/terraform-modules/pull/432) Add deletion protection to Flux components to prevent unwanted removal of critical components.
- [#439](https://github.com/XenitAB/terraform-modules/pull/439) Add information about Azure AD Graph deprecation.
- [#440](https://github.com/XenitAB/terraform-modules/pull/440) Allow scale down for nodes with local storage.

### Fixed

- [#442](https://github.com/XenitAB/terraform-modules/pull/442) Fix Datadog monitoring of ingress-nginx and enable x-forwarded-for headers.

## 2021.10.3

### Fixed

- [#431](https://github.com/XenitAB/terraform-modules/pull/431) Downgrade external-dns helm chart to 5.4.8 and external-dns to 0.9.0

## 2021.10.2

### Added

- [#416](https://github.com/XenitAB/terraform-modules/pull/416) Enable Prometheus pod monitoring for azad-kube-proxy.
- [#420](https://github.com/XenitAB/terraform-modules/pull/420) Add support for New Relic metrics and log exporting. This feature is optional opt-in and will have no effect on current deployments.
- [#424](https://github.com/XenitAB/terraform-modules/pull/424) Add CI step to check if CHANGELOG.md is updated in your PR. If you want to ignore it
  add "ignore-changelog" label to your PR.
- [#413](https://github.com/XenitAB/terraform-modules/pull/413) Add flow-log option to AWS, this is only meant for debugging and thus is disabled by default. If you run this in production it will be expensive fast.

### Changed

- [#415](https://github.com/XenitAB/terraform-modules/pull/415) Migrate from azdo-proxy to git-auth-proxy and update GitHub FluxV2 module to work with git-auth-proxy.
- [#418](https://github.com/XenitAB/terraform-modules/pull/418) [Breaking] Update the Flux provider version to 0.4.0. Check the [provider release](https://github.com/fluxcd/terraform-provider-flux/blob/main/CHANGELOG.md#040) for migration instructions.

### Fixed

- [#423](https://github.com/XenitAB/terraform-modules/pull/423) Fix enabling monitors from aks-core and eks-core.
- [#425](https://github.com/XenitAB/terraform-modules/pull/425) Switch to using https endpoint when scraping kubelet metrics in EKS.
- [#426](https://github.com/XenitAB/terraform-modules/pull/426) Remove CPU limit in csi secrets driver as it could cause high throttling.

### Deprecated

- [#428](https://github.com/XenitAB/terraform-modules/pull/428) Deprecate kyverno and external-secrets modules.
