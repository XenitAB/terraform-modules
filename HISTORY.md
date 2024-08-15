# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Calendar Versioning](https://calver.org/).

## 2023.10.2

### Changed

- [#1038](https://github.com/XenitAB/terraform-modules/pull/1038) Fix enviroment in ingress-healthz return.

## 2023.10.1

### Changed

- [#1025](https://github.com/XenitAB/terraform-modules/pull/1025) Enable Spegel mirroring for private ACR registry.
- [#1033](https://github.com/XenitAB/terraform-modules/pull/1033) Migrate ingress-healthz to install with flux.
- [#1035](https://github.com/XenitAB/terraform-modules/pull/1035) Fix ingress-healthz kustomization health check.

### Added

- [#1027](https://github.com/XenitAB/terraform-modules/pull/1027) Add purge task to remove old images from ACR.

## 2023.08.2

### Changed

- [#1024](https://github.com/XenitAB/terraform-modules/pull/1024) Update provider versions.

### Added

- [#1023](https://github.com/XenitAB/terraform-modules/pull/1023) Set OS upgrade explicitly to Unmanaged.

## 2023.08.1

### Added

- [#1017](https://github.com/XenitAB/terraform-modules/pull/1017) Add support for kubernetes 1.26.
- [#1016](https://github.com/XenitAB/terraform-modules/pull/1016) Add variable for VMSS diff disk placement for GitHub Runners.
- [#1010](https://github.com/XenitAB/terraform-modules/pull/1010) Add azureFile CSI storage classes.

### Changed

- [#1009](https://github.com/XenitAB/terraform-modules/pull/1009) Set allow_nested_items_to_be_public in SAs false.
- [#1020](https://github.com/XenitAB/terraform-modules/pull/1020) Enabled Azure Disk Encryption ability for Key Vaults.

## 2023.06.5

### Added

- [#1000](https://github.com/XenitAB/terraform-modules/pull/1000) Add OTLP support in datadog-agent.

### Changed

- [#1001](https://github.com/XenitAB/terraform-modules/pull/1001) Migrate node-ttl to install with Flux.
- [#1002](https://github.com/XenitAB/terraform-modules/pull/1002) Migrate spegel to install with Flux.
- [#1006](https://github.com/XenitAB/terraform-modules/pull/1006) Update Git provider.
- [#1005](https://github.com/XenitAB/terraform-modules/pull/1005) Migrate node-local-dns to install with Flux.
- [#1007](https://github.com/XenitAB/terraform-modules/pull/1007) Migrate vpa to install with Flux.
- [#1003](https://github.com/XenitAB/terraform-modules/pull/1003) Migrate gatekeeper to install with Flux.
- [#1003](https://github.com/XenitAB/terraform-modules/pull/1012) Make Availability Zones configurable for AKS.

## 2023.06.4

### Fixed

- [#995](https://github.com/XenitAB/terraform-modules/pull/995) Fix Kubernetes version validation.

### Changed

- [#989](https://github.com/XenitAB/terraform-modules/pull/989) Update Azad-Kube-Proxy to v0.0.47.
- [#996](https://github.com/XenitAB/terraform-modules/pull/996) Rename Datadog agent.
- [#992](https://github.com/XenitAB/terraform-modules/pull/992) Add AKS cluster principal_id to aksmsi group.
- [#997](https://github.com/XenitAB/terraform-modules/pull/997) Add health checks to Datadog.
- [#998](https://github.com/XenitAB/terraform-modules/pull/998) Update GitHub Terraform provider to 5.28.0.

## 2023.06.3

### Changed

- [#994](https://github.com/XenitAB/terraform-modules/pull/994) Update Datadog agent config.

## 2023.06.2

### Added

- [#991](https://github.com/XenitAB/terraform-modules/pull/991) Add vnet role assignment.

### Changed

- [#988](https://github.com/XenitAB/terraform-modules/pull/988) Update Azurerm provider version and enable AKS workload identities.
- [#982](https://github.com/XenitAB/terraform-modules/pull/972) Update datadog-operator to 1.0.2 and agent to v2alpha1.

## 2023.06.1

### Changed

- [#972](https://github.com/XenitAB/terraform-modules/pull/968) Update Datadog to install with flux.

## 2023.04.3

### Added

- [#985](https://github.com/XenitAB/terraform-modules/pull/985) Manage Flux notification provider.

### Changed

- [#983](https://github.com/XenitAB/terraform-modules/pull/983) Update Flux to 0.25.3.
- [#984](https://github.com/XenitAB/terraform-modules/pull/984) Update Spegel to v0.0.7.
- [#986](https://github.com/XenitAB/terraform-modules/pull/986) Update Flux CRD versions.

## 2023.04.2

### Fixed

- [#980](https://github.com/XenitAB/terraform-modules/pull/980) Re-enable option to disable unique suffixes for resource group key vaults.

## 2023.04.1

### Changed

- [#973](https://github.com/XenitAB/terraform-modules/pull/973) Switch to Standard sku_tier due to deprecations in the AzureAPI.
- [#970](https://github.com/XenitAB/terraform-modules/pull/970) Update Azurerm provider to 3.51.0.
- [#974](https://github.com/XenitAB/terraform-modules/pull/974) Update Spegel to v0.0.6.

### Added

- [#971](https://github.com/XenitAB/terraform-modules/pull/971) Add variable for EBS volume size.
- [#958](https://github.com/XenitAB/terraform-modules/pull/958) Make azure/governance and azure/core use the [aztfmod/azurecaf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs) provider for names.

## 2023.03.2

### Changed

- [#957](https://github.com/XenitAB/terraform-modules/pull/957) Update Spegel to v0.0.5 and set resources.
- [#959](https://github.com/XenitAB/terraform-modules/pull/959) Update node-local-dns to 1.22.20 and move to using registry.k8s.io.
- [#962](https://github.com/XenitAB/terraform-modules/pull/962) Update Cluster Autoscaler Helm chart to move to using registry.k8s.io.
- [#960](https://github.com/XenitAB/terraform-modules/pull/960) Update Goldilocks and VPA and move to using registry.k8s.io.
- [#961](https://github.com/XenitAB/terraform-modules/pull/961) Update CSI secret store and move to using registry.k8s.io.
- [#963](https://github.com/XenitAB/terraform-modules/pull/963) Update Kube State Metrics and move to using registry.k8s.io.
- [#965](https://github.com/XenitAB/terraform-modules/pull/965) Update AAD Pod Identity to chart version 4.1.16 with app version 1.8.15.

### Fixed

- [#964](https://github.com/XenitAB/terraform-modules/pull/964) Fix CRD versions.

## 2023.03.1

### Added

- [#943](https://github.com/XenitAB/terraform-modules/pull/943) Make private endpoint network policies configurable.
- [#951](https://github.com/XenitAB/terraform-modules/pull/951) Add Spegel service monitor.

### Changed

- [#945](https://github.com/XenitAB/terraform-modules/pull/945) Increase flux gitrepository timeout to 120s.
- [#947](https://github.com/XenitAB/terraform-modules/pull/947) Bump git-auth-proxy to v0.8.2.
- [#946](https://github.com/XenitAB/terraform-modules/pull/946) [Breaking] Enable configuration for private and public ingress controllers.
- [#949](https://github.com/XenitAB/terraform-modules/pull/949) Update audit log alert criteria.
- [#954](https://github.com/XenitAB/terraform-modules/pull/954) Make audit log alert have bigger window_size and frequency.

### Fixed

- [#952](https://github.com/XenitAB/terraform-modules/pull/952) Fix issues created by #943 and change core to use new private_endpoint_network_policies_enabled in core subnet config.

## 2023.02.3

### Changed

- [#939](https://github.com/XenitAB/terraform-modules/pull/939) Update Spegel to v0.0.4 and fix misspelled Spegel namespace.

## 2023.02.2

### Added

- [#934](https://github.com/XenitAB/terraform-modules/pull/934) Add certificate permissions for resource group AAD group.
- [#906](https://github.com/XenitAB/terraform-modules/pull/906) Add support for kubernetes 1.25 in Azure.
- [#936](https://github.com/XenitAB/terraform-modules/pull/936) Add Spegel to AKS and EKS.

### Changed

- [#928](https://github.com/XenitAB/terraform-modules/pull/928) Enable Node TTL by default.
- [#929](https://github.com/XenitAB/terraform-modules/pull/928) Make allow_gateway_transit configurable.
- [#935](https://github.com/XenitAB/terraform-modules/pull/935) Update Node TTL to v0.0.6 and enable monitoring.
- [#933](https://github.com/XenitAB/terraform-modules/pull/933) Change from starboard to trivy-operator.

## 2023.02.1

### Changed

- [#917](https://github.com/XenitAB/terraform-modules/pull/917) Remove datasource for azuread_groups in xkf_governance_global.
- [#920](https://github.com/XenitAB/terraform-modules/pull/920) Increase default AKS audit retention to 365 days.
- [#926](https://github.com/XenitAB/terraform-modules/pull/926) Make disable_bgp_route_propagation configurable.
- [#916](https://github.com/XenitAB/terraform-modules/pull/916) Update Node TTL to v0.0.5.

### Fix

- [#856](https://github.com/XenitAB/terraform-modules/pull/856) Update falco to v0.33.0 and falco-exporter to v0.8.0.
- [#918](https://github.com/XenitAB/terraform-modules/pull/918) Update workflows with new action versions

### Added

- [#897](https://github.com/XenitAB/terraform-modules/pull/897) Add Datadog APM ignore resources
- [#921](https://github.com/XenitAB/terraform-modules/pull/921) Add Azure Alerts if no data gets sent to log storage account.
- [#922](https://github.com/XenitAB/terraform-modules/pull/922) Enable use of spot instances in AKS

## 2023.01.2

### Changed

- [#909](https://github.com/XenitAB/terraform-modules/pull/909) Update Azure provider.
- [#910](https://github.com/XenitAB/terraform-modules/pull/910) Disable AKS file driver and snapshot controller.

### Fix

- [#911](https://github.com/XenitAB/terraform-modules/pull/911) Fix Node TTL status ConfigMap namespace for AKS.

## 2023.01.1

### Added

- [#894](https://github.com/XenitAB/terraform-modules/pull/894) Add x509-certificate-exporter helm chart.

### Changed

- [#892](https://github.com/XenitAB/terraform-modules/pull/892) Change the default Prometheus scrape interval to every minute.
- [#896](https://github.com/XenitAB/terraform-modules/pull/896) Update external-dns and metrics-server.
- [#900](https://github.com/XenitAB/terraform-modules/pull/900) Trigger upgrade pipeline in xkf-templates at release
- [#902](https://github.com/XenitAB/terraform-modules/pull/902) Update cluster-autoscaler to 1.24.
- [#903](https://github.com/XenitAB/terraform-modules/pull/903) Update Node TTL to v0.0.4.
- [#905](https://github.com/XenitAB/terraform-modules/pull/905) Update Prometheus to v2.41.0.

### Fix

- [#907](https://github.com/XenitAB/terraform-modules/pull/907) Add node labels and taints as tags to ASG.

## 2022.12.3

### Fix

- [#890](https://github.com/XenitAB/terraform-modules/pull/890) Include specific api server metrics.

## 2022.12.2

### Fix

- [#882](https://github.com/XenitAB/terraform-modules/pull/882) Platform workloads ignore taints and labels.
- [#883](https://github.com/XenitAB/terraform-modules/pull/883) Fix promtail configuration.
- [#884](https://github.com/XenitAB/terraform-modules/pull/884) Fix cluster-role-binding for get-nodes role in eks.
- [#887](https://github.com/XenitAB/terraform-modules/pull/887) Add label and taint tags to eks node group.

### Changed

- [#877](https://github.com/XenitAB/terraform-modules/pull/877) [Breaking] Update Kube Prometheus Stack to 42.1.1.
- [#878](https://github.com/XenitAB/terraform-modules/pull/878) Disable collecting API Server metrics.
- [#879](https://github.com/XenitAB/terraform-modules/pull/879) Update Promtail Helm chart to 6.6.2.
- [#881](https://github.com/XenitAB/terraform-modules/pull/881) Set OPA mutatingWebhookReinvocationPolicy: IfNeeded.
- [#885](https://github.com/XenitAB/terraform-modules/pull/885) OPA mutatingWebhookCustomRules trigger ephemeralContainer.
- [#886](https://github.com/XenitAB/terraform-modules/pull/886) [Breaking] Update OPA lib to 0.20.1, use Xenit pspReadOnlyRoot and new assign rule for ephemeral containers.
- [#888](https://github.com/XenitAB/terraform-modules/pull/888) Upgrade ingress-nginx helm to 4.4.0.

## 2022.12.1

### Added

- [#857](https://github.com/XenitAB/terraform-modules/pull/857) Grafana agent kubelet metrics.

### Fixed

- [#871](https://github.com/XenitAB/terraform-modules/pull/871) Change ingress-nginx affinity match labels.
- [#873](https://github.com/XenitAB/terraform-modules/pull/873) Add linkerd exception to default-deny networkpolicy.

### Changed

- [#874](https://github.com/XenitAB/terraform-modules/pull/874) Update linkerd to 2.12.2.

## 2022.11.2

### Added

- [#861](https://github.com/XenitAB/terraform-modules/pull/861) Add support for kubernetes 1.24 in AWS.
- [#869](https://github.com/XenitAB/terraform-modules/pull/869) Add support to set taint on EKS node pool.

### Fixed

- [#865](https://github.com/XenitAB/terraform-modules/pull/865) Make azad-kube-proxy AD group filter more specific.

## 2022.11.1

### Fixed

- [#821](https://github.com/XenitAB/terraform-modules/pull/821) Default ingressClassName for ingress_healthz.
- [#847](https://github.com/XenitAB/terraform-modules/pull/847) Fix linkerd certificate forced recreation.
- [#850](https://github.com/XenitAB/terraform-modules/pull/850) Allow overriding ACR name.

### Changed

- [#849](https://github.com/XenitAB/terraform-modules/pull/849) Bump azad-kube-proxy version to 0.0.36.
- [#848](https://github.com/XenitAB/terraform-modules/pull/848) Allow aks name suffix to be set to null.
- [#841](https://github.com/XenitAB/terraform-modules/pull/841) Change ACR SKU to Standard.
- [#846](https://github.com/XenitAB/terraform-modules/pull/846) Add XKF prefix to node pool label.
- [#853](https://github.com/XenitAB/terraform-modules/pull/853) Upgrade azad-kube-proxy version.
- [#854](https://github.com/XenitAB/terraform-modules/pull/854) Explicitly set Prometheus version that should be used.

## 2022.10.3

### Changed

- [#837](https://github.com/XenitAB/terraform-modules/pull/837) Update TFLint to 0.42.
- [#838](https://github.com/XenitAB/terraform-modules/pull/838) Update git-auth-proxy to v0.8.1.
- [#840](https://github.com/XenitAB/terraform-modules/pull/840) Add support for ARM VMs in AKS.

### Added

- [#836](https://github.com/XenitAB/terraform-modules/pull/836) Make purge protection configurable per keyvault.

### Fixed

- [#835](https://github.com/XenitAB/terraform-modules/pull/835) Make falco use priorityClassName again.

### Removed

- [#839](https://github.com/XenitAB/terraform-modules/pull/839) Remove deprecated Flux V1 module.

## 2022.10.2

### Changed

- [830](https://github.com/XenitAB/terraform-modules/pull/830) Add unique_suffix to core delegate azurerm_role_definition service_endpoint_join.
- [832](https://github.com/XenitAB/terraform-modules/pull/832) Upgrade azurerm provider to 3.28.0.

## 2022.10.1

### Added

- [#823](https://github.com/XenitAB/terraform-modules/pull/823) Add secrets-store.csi.x-k8s.io to EKS tenants.

### Changed

- [#812](https://github.com/XenitAB/terraform-modules/pull/812) Upgrade terraform to 1.3.0.
- [#810](https://github.com/XenitAB/terraform-modules/pull/810) Update provider versions.
- [#814](https://github.com/XenitAB/terraform-modules/pull/814) Possible to use data source as policy input to Irsa.
- [#816](https://github.com/XenitAB/terraform-modules/pull/816) Update node local dns version.

### Fixed

- [#815](https://github.com/XenitAB/terraform-modules/pull/815) Make datadog tolerate all node taints.
- [#822](https://github.com/XenitAB/terraform-modules/pull/822) Update secrets-store.csi.x-k8s.io from v1alpha1 to v1.

## 2022.09.2

### Added

- [#787](https://github.com/XenitAB/terraform-modules/pull/787) Add support for kubernetes 1.24 in Azure.
- [#797](https://github.com/XenitAB/terraform-modules/pull/797) [Breaking] Add option to configure extra headers in Ingress NGINX.
- [#796](https://github.com/XenitAB/terraform-modules/pull/796) Add custom resource edit rights to tenant service account.
- [#791](https://github.com/XenitAB/terraform-modules/pull/791) Add control-plane output solution for Azure.

### Changed

- [#783](https://github.com/XenitAB/terraform-modules/pull/783) Upgrade azurerm and azuread providers.
- [#789](https://github.com/XenitAB/terraform-modules/pull/789) [Breaking] Image gallery support for Azure Pipelines module.
- [#801](https://github.com/XenitAB/terraform-modules/pull/801) [Breaking] Image gallery support for Github Runners module.
- [#802](https://github.com/XenitAB/terraform-modules/pull/802) Ignore commit message changes in Flux installations.
- [#807](https://github.com/XenitAB/terraform-modules/pull/807) Increase NGINX Ingress min availible from one to two.

### Fixed

- [#788](https://github.com/XenitAB/terraform-modules/pull/788) Stop role assignment recreation on AKS cluster update.
- [#793](https://github.com/XenitAB/terraform-modules/pull/793) Downgrade AWS calico to 3.19 and upgrade ingress-nginx config and version.

### Deprecated

- [#800](https://github.com/XenitAB/terraform-modules/pull/800) Deprecate FLuxcd v1 module.

### Removed

- [#806](https://github.com/XenitAB/terraform-modules/pull/806) [Breaking] Remove creation of service accounts for tenant namespaces.

## 2022.09.1

### Added

- [#774](https://github.com/XenitAB/terraform-modules/pull/774) [Breaking] Add extra_config to ingress nginx config object.
- [#780](https://github.com/XenitAB/terraform-modules/pull/780) Add AWS CSI driver to EKS cluster.

### Changed

- [#778](https://github.com/XenitAB/terraform-modules/pull/778) Upgrade AWS calico to 3.24.
- [#776](https://github.com/XenitAB/terraform-modules/pull/776) [Breaking] Remove default value for unique_suffix in Azure core module.
- [#775](https://github.com/XenitAB/terraform-modules/pull/775) Update falco helm chart to 2.0.16.
- [#777](https://github.com/XenitAB/terraform-modules/pull/777) Update Flux 2.0 to v0.33.0 which bumps the source controller from v1beta1 to v1betav2.

## 2022.08.3

### Added

- [#715](https://github.com/XenitAB/terraform-modules/pull/715) Long term storage of AKS audit logs.
- [#767](https://github.com/XenitAB/terraform-modules/pull/767) Helm-crd-oci module to support helm charts located in OCI.

### Fixed

- [#764](https://github.com/XenitAB/terraform-modules/pull/764) Fix Linkerd cert expiring 8 years too early.
- [#765](https://github.com/XenitAB/terraform-modules/pull/764) Replace Linkerd image registry with ghcr.
- [#766](https://github.com/XenitAB/terraform-modules/pull/766) Skip Linkerd proxy for Ingress Nginx webhook.
- [#768](https://github.com/XenitAB/terraform-modules/pull/768) Use linkerd-fork OCI helm charts and update linkerd to 2.12.0.
- [#771](https://github.com/XenitAB/terraform-modules/pull/771) Make region optinal in ingress-health fqdn.
- [#772](https://github.com/XenitAB/terraform-modules/pull/772) Use correct linkerd-cni chart name.

## 2022.08.2

### Changed

- [#691](https://github.com/XenitAB/terraform-modules/pull/691) [Breaking] Refactor modules to support multi region setup.

## 2022.08.1

### Changed

- [#756](https://github.com/XenitAB/terraform-modules/pull/756) Update terraform and tooling.
- [#759](https://github.com/XenitAB/terraform-modules/pull/759) Update Terraform tls provider to 4.0.1.
- [#760](https://github.com/XenitAB/terraform-modules/pull/760) Move secrets-store-csi-driver-provider-azure helm chart location.

### Fixed

- [#743](https://github.com/XenitAB/terraform-modules/pull/743) Add cert permissions to group owners.

## 2022.07.2

### Added

- [#744](https://github.com/XenitAB/terraform-modules/pull/744) Add configurable external_dns_hostname annotation for ingress-nginx.
- [#753](https://github.com/XenitAB/terraform-modules/pull/753) Add support for kubernetes version 1.23.

### Changed

- [#745](https://github.com/XenitAB/terraform-modules/pull/745) Update ingress-nginx to 4.2.0 and disable chroot image in AWS.
- [#748](https://github.com/XenitAB/terraform-modules/pull/748) Enable chroot image on AWS and set a custom internal-logger-address when running in AWS and multiple internal_load_balancer.
- [#749](https://github.com/XenitAB/terraform-modules/pull/749) Update gatekeeper to 3.9.0.

### Fixed

- [#746](https://github.com/XenitAB/terraform-modules/pull/746) Install VPA crd from correct helm chart.
- [#747](https://github.com/XenitAB/terraform-modules/pull/747) Cert-manager AWS webhook config was broken due to replica of yaml config in helm.

## 2022.07.1

### Added

- [#735](https://github.com/XenitAB/terraform-modules/pull/735) [Breaking] Add the possibility to ignore unique suffix in key-vault creation.
- [#739](https://github.com/XenitAB/terraform-modules/pull/739) Enable tenants to read VPA config in there namespace.
- [#740](https://github.com/XenitAB/terraform-modules/pull/740) [Breaking] Make AWS assume EKS Admin role configurable.

### Changed

- [#741](https://github.com/XenitAB/terraform-modules/pull/741) Update linkerd control-plane to 1.5.4-edge.
- [#738](https://github.com/XenitAB/terraform-modules/pull/738) Disable datadog-operator crd installation.
- [#736](https://github.com/XenitAB/terraform-modules/pull/736) Update FluxV1 and Helm Operator.

## 2022.06.3

### Added

- [#728](https://github.com/XenitAB/terraform-modules/pull/728) Add the possibility to override public ip prefix name in aks global.

### Changed

- [#714](https://github.com/XenitAB/terraform-modules/pull/714) Ingress-nginx helm chart 4.1.4 and use the chroot functionality.
- [#721](https://github.com/XenitAB/terraform-modules/pull/721) Allow datadog ingress by default to tenant namespace.
- [#724](https://github.com/XenitAB/terraform-modules/pull/724) Upgrade azad-kube-proxy to 0.0.34.
- [#727](https://github.com/XenitAB/terraform-modules/pull/727) Upgrade git-auth-proxy to v0.7.2.
- [#732](https://github.com/XenitAB/terraform-modules/pull/732) Set resource request and limits to Node TTL.

### Fixed

- [#716](https://github.com/XenitAB/terraform-modules/pull/716) Set resource requests for datadog-cluster-agent, starboard-operator, ingress-nginx, external-dns, azure-metrics and goldilocks-controller.
- [#717](https://github.com/XenitAB/terraform-modules/pull/717) Remove force conflicts from CRD resource.
- [#718](https://github.com/XenitAB/terraform-modules/pull/718) Remove node pool create before destroy.
- [#719](https://github.com/XenitAB/terraform-modules/pull/719) Update Flux v1 helm operator rbac to v1.
- [#733](https://github.com/XenitAB/terraform-modules/pull/733) Add resource definitions for datadog agent, cert-manager, reloader, prometheus kube-state-metrics.

## 2022.06.2

### Changed

- [#640](https://github.com/XenitAB/terraform-modules/pull/640) [Breaking] AKS set kubelet config default max pod pid to 1000.
- [#709](https://github.com/XenitAB/terraform-modules/pull/709) [Breaking] Upgrade linkerd CNI to 2.11.2 and control-plane to edge-22.6.1.
- [#710](https://github.com/XenitAB/terraform-modules/pull/710) Increase Prometheus resource request and limit.
- [#712](https://github.com/XenitAB/terraform-modules/pull/712) Set resoleve conflicts to overwrite for EKS addons.

## 2022.06.1

### Fix

- [#690](https://github.com/XenitAB/terraform-modules/pull/690) Helm metrics-server extraArgs as list.
- [#697](https://github.com/XenitAB/terraform-modules/pull/697) Set default environment in datadog agent.
- [#700](https://github.com/XenitAB/terraform-modules/pull/700) Fix node-ttl OCI registry.
- [#701](https://github.com/XenitAB/terraform-modules/pull/701) Datadog nginx-ingress-controller log config.
- [#703](https://github.com/XenitAB/terraform-modules/pull/703) Exclude prometheus ns from gatekeeper config.

### Added

- [#692](https://github.com/XenitAB/terraform-modules/pull/692) [Breaking] Add Node TTL to EKS and AKS.

### Changed

- [#636](https://github.com/XenitAB/terraform-modules/pull/636) Make Node Local DNS enabled by default in AWS and Azure.
- [#688](https://github.com/XenitAB/terraform-modules/pull/688) Fix Kubernetes version check and update supported versions.
- [#654](https://github.com/XenitAB/terraform-modules/pull/654) AWS specify last addon version in EKS.
- [#698](https://github.com/XenitAB/terraform-modules/pull/698) Add premium ZRS storage class to AKS.
- [#699](https://github.com/XenitAB/terraform-modules/pull/698) Update Helm Terraform provider to support OCI charts.
- [#707](https://github.com/XenitAB/terraform-modules/pull/707) Update bitnami/nginx helm chart to 12.0.3 for ingress-healthz.

## 2022.05.4

### Changed

- [#684](https://github.com/XenitAB/terraform-modules/pull/684) Update aad pod identity.
- [#685](https://github.com/XenitAB/terraform-modules/pull/685) Update csi secrets store.
- [#686](https://github.com/XenitAB/terraform-modules/pull/686) Update Datadog Operator, Kube Prometheus Stack and Metrics Server.

## 2022.05.3

### Changed

- [#664](https://github.com/XenitAB/terraform-modules/pull/664) Manage Helm chart CRDs outside of Helm.
- [#678](https://github.com/XenitAB/terraform-modules/pull/678) Update OPA to 3.8.1, gatekeeper-library to 0.12.1 and add k8srequireingressclass constraint.
- [#679](https://github.com/XenitAB/terraform-modules/pull/679) Update AzureRM provider version.
- [#680](https://github.com/XenitAB/terraform-modules/pull/680) Disable AKS run command.
- [#682](https://github.com/XenitAB/terraform-modules/pull/680) Fix CRD server side apply conflicts.
- [#683](https://github.com/XenitAB/terraform-modules/pull/680) Fix datadog cluster agent pdb.

## 2022.05.2

### Changed

- [#666](https://github.com/XenitAB/terraform-modules/pull/666) Enable ingress-nginx logs in promtail.
- [#670](https://github.com/XenitAB/terraform-modules/pull/670) Ingress-nginx default wildcard certificate enabled.

### Fix

- [#671](https://github.com/XenitAB/terraform-modules/pull/671) [Breaking] Governance delegate-se from regional to global module.
- [#672](https://github.com/XenitAB/terraform-modules/pull/672) Fix EKS version validation

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
