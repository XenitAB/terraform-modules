# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Calendar Versioning](https://calver.org/).

## Unreleased

## 2022.05.1

### Changed

- [#651](https://github.com/XenitAB/terraform-modules/pull/651) OPA add seccomp profile and disable default mount of SA token.
- [#645](https://github.com/XenitAB/terraform-modules/pull/645) [Breaking] Refactor AKS node configuration with default values.
- [#659](https://github.com/XenitAB/terraform-modules/pull/659) [Breaking] Bring AKS and EKS config inline with each other.
- [#653](https://github.com/XenitAB/terraform-modules/pull/653) Add validation of Kubernetes version in EKS and AKS.
- [#662](https://github.com/XenitAB/terraform-modules/pull/662) Modify FluxV2 installation to never remove applied resource.
- [#663](https://github.com/XenitAB/terraform-modules/pull/663) Set max history to Helm releases missing configuration.

### Fix

- [#661](https://github.com/XenitAB/terraform-modules/pull/661) Fix cluster-role-binding for get-nodes role.
- [#658](https://github.com/XenitAB/terraform-modules/pull/658) Remove 'use-forwarded-headers: "true"' from ingress-nginx

## 2022.04.3

### Changed

- [#648](https://github.com/XenitAB/terraform-modules/pull/648) [Breaking] Make it possible to exclude namespaces from Datadog
- [#656](https://github.com/XenitAB/terraform-modules/pull/656) Update Ingress Nginx version to mitigate security disclosure.

### Fix

- [#650](https://github.com/XenitAB/terraform-modules/pull/650) Make it possible to enable Promtail metrics in eks-core

### Added

- [#647](https://github.com/XenitAB/terraform-modules/pull/647) [Breaking] Create Azure AD Application for azad-kube-proxy using eks-global.

## 2022.04.2

### Added

- [#639](https://github.com/XenitAB/terraform-modules/pull/639) Create Azure AD Application for azad-kube-proxy using aks-global

### Changed

- [#635](https://github.com/XenitAB/terraform-modules/pull/635) Upgrade azurerm provider to v3.1.0.
- [#637](https://github.com/XenitAB/terraform-modules/pull/637) [Breaking] Add tenant namespace default deny network policy by default.
- [#638](https://github.com/XenitAB/terraform-modules/pull/638) Set default empty config for `promtail_config` in `aks-core` and `eks-core`
- [#642](https://github.com/XenitAB/terraform-modules/pull/642) Add toleration for Promtail to make it run on all nodes.
- [#643](https://github.com/XenitAB/terraform-modules/pull/643) Change tenant label name for Promtail.
- [#644](https://github.com/XenitAB/terraform-modules/pull/644) Update OPA Gatekeeper Library to v0.12.0.

### Removed

- [#633](https://github.com/XenitAB/terraform-modules/pull/633) Remove deperecated modules xenit, loki, and new-relic.

## 2022.04.1

### Added

- [#624](https://github.com/XenitAB/terraform-modules/pull/624) Add Promtail for platform logs in Azure.
- [#630](https://github.com/XenitAB/terraform-modules/pull/630) Add variable for exluding Promtail namespaces.
- [#632](https://github.com/XenitAB/terraform-modules/pull/632) Make Promtail work for AWS/EKS.

### Changed

- [#622](https://github.com/XenitAB/terraform-modules/pull/622) [Breaking] Hardcode prometheus and trivy storage class.
- [#617](https://github.com/XenitAB/terraform-modules/pull/617) Upgrade falco to 0.31.1
- [#536](https://github.com/XenitAB/terraform-modules/pull/536) Update OPA Gatekeeper Helm charts
- [#626](https://github.com/XenitAB/terraform-modules/pull/626) [Breaking] Add support for multiple DNS zones.
- [#590](https://github.com/XenitAB/terraform-modules/pull/590) Drop CAP_SYS_ADMIN through OPA and use gatekeeper-library v0.10.0.

### Fix

- [#620](https://github.com/XenitAB/terraform-modules/pull/620) Fix broken cluster autoscaler
- [#623](https://github.com/XenitAB/terraform-modules/pull/623) Falco AWS disable docker

### Deprecated

- [#627](https://github.com/XenitAB/terraform-modules/pull/627) Deprecate loki and xenit modules.

## 2022.03.5

### Changed

- [#618](https://github.com/XenitAB/terraform-modules/pull/618) Create new EKS and AKS node pools before deleting existing node pools.
- [#614](https://github.com/XenitAB/terraform-modules/pull/614) Upgrade AWS provider to 4.6.0

## 2022.03.4

### Fix

- [#606](https://github.com/XenitAB/terraform-modules/pull/606) Fix electionID on ingress-nginx when using private and public ingress-nginx.
- [#608](https://github.com/XenitAB/terraform-modules/pull/608) Include node-local-dns IP in default-deny networkpolicy CIDR block.
- [#611](https://github.com/XenitAB/terraform-modules/pull/611) Add option to turn off ingress-nginx metrics in grafana.
- [#610](https://github.com/XenitAB/terraform-modules/pull/610) Add prefetch and serve_stale dns config to node-local-dns.

### Changed

- [#607](https://github.com/XenitAB/terraform-modules/pull/607) [Breaking] Upgrade terraform to 1.1.7.
- [#616](https://github.com/XenitAB/terraform-modules/pull/616) Require Terraform version >= 1.1.7 instead of explicit version.
- [#612](https://github.com/XenitAB/terraform-modules/pull/612) Update azure-metrics to 22.3.0 and gather more metrics.

## 2022.03.3

### Changed

- [#593](https://github.com/XenitAB/terraform-modules/pull/593) Change Prometheus remote write settings to align with best practices.
- [#574](https://github.com/XenitAB/terraform-modules/pull/574) [Breaking] Update cert-manager version.
- [#595](https://github.com/XenitAB/terraform-modules/pull/595) Update Terraform provider versions.

### Fix

- [#600](https://github.com/XenitAB/terraform-modules/pull/600) Hardcode trivy starboard image to 0.24.3 and update trivy helm chart.
- [#601](https://github.com/XenitAB/terraform-modules/pull/601) Fix api-group for get nodes role.

### Removed

- [#594](https://github.com/XenitAB/terraform-modules/pull/594) Remove deprecated goldpinger module.

### Deprecated

- [#597](https://github.com/XenitAB/terraform-modules/pull/597) Deprecate New Relic module.

## 2022.03.2

### Changed

- [#589](https://github.com/XenitAB/terraform-modules/pull/589) Update git-auth-proxy to 0.6.0 to include case-insensitive path matching.

### Fixed

- [#587](https://github.com/XenitAB/terraform-modules/pull/587) Fix space error in grafana-agent podLogs
- [#585](https://github.com/XenitAB/terraform-modules/pull/585) [Breaking] Upgrade Azure AD provider to v2

## 2022.03.1

### Added

- [#571](https://github.com/XenitAB/terraform-modules/pull/571) Add storageClass in AKS to enable StandardSSD_ZRS.

### Changed

- [#537](https://github.com/XenitAB/terraform-modules/pull/537) Support private repository scanning with starboard in AWS & Azure.
- [#565](https://github.com/XenitAB/terraform-modules/pull/565) [Breaking] Update Ingress Nginx major version.
- [#573](https://github.com/XenitAB/terraform-modules/pull/573) Update External DNS version.
- [#568](https://github.com/XenitAB/terraform-modules/pull/568) Add kube-state-metrics for tenant namespaces to grafana-agent
- [#577](https://github.com/XenitAB/terraform-modules/pull/577) Add ingress-nginx metrics and logs scraping to grafana-agent
- [#579](https://github.com/XenitAB/terraform-modules/pull/579) Send EKS audit and API logs to cloudwatch

### Fixed

- [#583](https://github.com/XenitAB/terraform-modules/pull/583) Use annotation-value-word-blocklist by default in Ingress-nginx
- [#570](https://github.com/XenitAB/terraform-modules/pull/570) Only add network policy for Datadog / Grafana-Agent if default deny is true
- [#582](https://github.com/XenitAB/terraform-modules/pull/582) Add the coreDNS ip to tenant networkpolicy CIDR block to work with node-local-dns.
  Use variable for node-local-dns.

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
