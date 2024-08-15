# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### 🚀 New Features
- Feat: add support for Azure service operator by @landerss1 in [#1149](https://github.com/XenitAB/terraform-modules/pulls/1149)
- Feat: disable or enable metrics alert when cluster is stopped or started by @landerss1 in [#1147](https://github.com/XenitAB/terraform-modules/pulls/1147)
- Feat: make upgrade_settings configurable by @landerss1 in [#1136](https://github.com/XenitAB/terraform-modules/pulls/1136)
- Feat: add support for AKS cost analysis by @landerss1 in [#1126](https://github.com/XenitAB/terraform-modules/pulls/1126)
- Feat: add support for starting/stopping a cluster using Azure automation by @landerss1 in [#1120](https://github.com/XenitAB/terraform-modules/pulls/1120)
- Feat: upgrade and add x509 priorityClassName by @landerss1 in [#1113](https://github.com/XenitAB/terraform-modules/pulls/1113)
- Feat: add remote debug support by @landerss1 in [#1068](https://github.com/XenitAB/terraform-modules/pulls/1068)
- Feat: add feature to override name of flux repo by @landerss1 in [#1109](https://github.com/XenitAB/terraform-modules/pulls/1109)



### 🐛 Bug Fixes
- Fix: aks automation module dependent on aks cluster by @landerss1 in [#1146](https://github.com/XenitAB/terraform-modules/pulls/1146)
- Fix: rego errors in gatekeeper templates by @landerss1 in [#1144](https://github.com/XenitAB/terraform-modules/pulls/1144)
- Fix: allow vector to use writable root file system by @landerss1 in [#1128](https://github.com/XenitAB/terraform-modules/pulls/1128)
- Fix: allow prometheus-node-exporter to use host network/port by @landerss1 in [#1127](https://github.com/XenitAB/terraform-modules/pulls/1127)
- Fix: add a private ingressclass instead of replacing the existing by @landerss1 in [#1110](https://github.com/XenitAB/terraform-modules/pulls/1110)



### 🚜 Refactor
- Refactor: update of the default log retention time for azure to 30 days by @yabracadabra in [#1140](https://github.com/XenitAB/terraform-modules/pulls/1140)



### ⚙️ Miscellaneous
- Chore: update spegel to 0.0.23 by @yabracadabra in [#1134](https://github.com/XenitAB/terraform-modules/pulls/1134)
- Chore: bump peter-evans/create-pull-request to v6 by @landerss1 in [#1132](https://github.com/XenitAB/terraform-modules/pulls/1132)
- Ci: run check when PR is labeled by @landerss1 in [#1131](https://github.com/XenitAB/terraform-modules/pulls/1131)
- Ci: don't include update of CHANGELOG in the CHANGELOG by @landerss1 in [#1129](https://github.com/XenitAB/terraform-modules/pulls/1129)
- Chore: bump ytanikin/PRConventionalCommits from 1.1.0 to 1.2.0 by @landerss1 in [#1115](https://github.com/XenitAB/terraform-modules/pulls/1115)
- Chore: bump azurerm provider to v3.107.0 by @landerss1 in [#1122](https://github.com/XenitAB/terraform-modules/pulls/1122)
- Ci: automate CHANGELOG with git-cliff by @landerss1 in [#1112](https://github.com/XenitAB/terraform-modules/pulls/1112)
- Chore: bump azuread provider to v2.50.0 by @landerss1 in [#1108](https://github.com/XenitAB/terraform-modules/pulls/1108)



### 📚 Documentation



## [2024.05.1](https://github.com/XenitAB/terraform-modules/releases/tag/2024.05.1)

### ⛓️‍💥 Breaking Changes
- Feat! migrate remaining platform modules to azure workload identity by @landerss1 in [#1103](https://github.com/XenitAB/terraform-modules/pulls/1103)
- Feat!: migrate grafana-agent to install with flux by @landerss1 in [#1099](https://github.com/XenitAB/terraform-modules/pulls/1099)
- Feat!: bump and migrate azure-metrics to workload identity and install with flux by @landerss1 in [#1082](https://github.com/XenitAB/terraform-modules/pulls/1082)



### 🚀 New Features
- Feat: Add possibility to use private ingress for azad-kube-proxy by @CalleB3 in [#1101](https://github.com/XenitAB/terraform-modules/pulls/1101)
- Feat: Add RBAC to allow customers more insight by @CalleB3 in [#1100](https://github.com/XenitAB/terraform-modules/pulls/1100)
- Add support for Azure policy add-on by @landerss1 in [#1070](https://github.com/XenitAB/terraform-modules/pulls/1070)
- Add support for Microsoft Defender for containers by @landerss1 in [#1071](https://github.com/XenitAB/terraform-modules/pulls/1071)
- Enable workload identity service account in tenant namespaces by @phillebaba in [#1066](https://github.com/XenitAB/terraform-modules/pulls/1066)
- Add support for creating additional k8s storage classes by @landerss1 in [#1064](https://github.com/XenitAB/terraform-modules/pulls/1064)
- Add functionality for multiple flux-tenants in one environment by @CalleB3 in [#1055](https://github.com/XenitAB/terraform-modules/pulls/1055)
- Add Owner SP to sub-owner group by @CalleB3 in [#1047](https://github.com/XenitAB/terraform-modules/pulls/1047)
- Add validation for 1.27 and 1.28 by @CalleB3 in [#1046](https://github.com/XenitAB/terraform-modules/pulls/1046)
- Add azad kube proxy password in core key vault by @landerss1 in [#1049](https://github.com/XenitAB/terraform-modules/pulls/1049)



### 🐛 Bug Fixes
- Fix: Velero bucket name and yaml formatting by @CalleB3 in [#1106](https://github.com/XenitAB/terraform-modules/pulls/1106)
- Fix: Velero storage account name format by @landerss1 in [#1105](https://github.com/XenitAB/terraform-modules/pulls/1105)
- Fix: deployment name in ingress-nginx healthcheck by @CalleB3 in [#1102](https://github.com/XenitAB/terraform-modules/pulls/1102)
- Fix: add dns01 nameserver config to cert-manager by @CalleB3 in [#1096](https://github.com/XenitAB/terraform-modules/pulls/1096)
- Fix: missing namespace labels by @landerss1 in [#1095](https://github.com/XenitAB/terraform-modules/pulls/1095)
- Fix(make): make lint work again by @landerss1 in [#1091](https://github.com/XenitAB/terraform-modules/pulls/1091)
- Fix aad-pod-identity kustomization healthcheck by @CalleB3 in [#1090](https://github.com/XenitAB/terraform-modules/pulls/1090)
- Fix: make include_tenant_name work by @CalleB3 in [#1089](https://github.com/XenitAB/terraform-modules/pulls/1089)
- Fix ingress-nginx multiple files collision when using public_private_enabled by @CalleB3 in [#1088](https://github.com/XenitAB/terraform-modules/pulls/1088)
- Fixed typo in contributing guide by @landerss1 in [#1051](https://github.com/XenitAB/terraform-modules/pulls/1051)
- Fix Client ID set to tenant service account by @landerss1 in [#1079](https://github.com/XenitAB/terraform-modules/pulls/1079)
- Fix name collision in identities when AKS does not have unique suffix by @phillebaba in [#1075](https://github.com/XenitAB/terraform-modules/pulls/1075)
- Fix reveresed logic for enabling defender by @landerss1 in [#1074](https://github.com/XenitAB/terraform-modules/pulls/1074)
- Migrate to opentofu by @landerss1 in [#1054](https://github.com/XenitAB/terraform-modules/pulls/1054)
- Fix ingress-healthz YAML for linkerd by @CalleB3 in [#1041](https://github.com/XenitAB/terraform-modules/pulls/1041)



### 🚜 Refactor
- Migrate Prometheus to install with flux by @CalleB3 in [#1093](https://github.com/XenitAB/terraform-modules/pulls/1093)
- Migrate cert-manager to install with flux by @CalleB3 in [#1087](https://github.com/XenitAB/terraform-modules/pulls/1087)
- Migrate control-plane-logs to install with flux by @landerss1 in [#1086](https://github.com/XenitAB/terraform-modules/pulls/1086)
- Migrate Velero to install with Flux by @landerss1 in [#1083](https://github.com/XenitAB/terraform-modules/pulls/1083)
- Migrate ingress-nginx to install with flux by @CalleB3 in [#1060](https://github.com/XenitAB/terraform-modules/pulls/1060)
- Migrate aad-pod-identity to install with flux by @CalleB3 in [#1061](https://github.com/XenitAB/terraform-modules/pulls/1061)
- Migrate trivy to install with flux by @landerss1 in [#1085](https://github.com/XenitAB/terraform-modules/pulls/1085)
- Migrate reloader to install with flux by @CalleB3 in [#1057](https://github.com/XenitAB/terraform-modules/pulls/1057)
- Migrate external-dns to install with Flux by @phillebaba in [#1014](https://github.com/XenitAB/terraform-modules/pulls/1014)
- Migrate diagnostic settings by @landerss1 in [#1050](https://github.com/XenitAB/terraform-modules/pulls/1050)



### ⚙️ Miscellaneous
- Remove slash in certmanager nameserver config by @CalleB3 in [#1097](https://github.com/XenitAB/terraform-modules/pulls/1097)
- Update ingress-healthz to 15.5.2 by @landerss1 in [#1052](https://github.com/XenitAB/terraform-modules/pulls/1052)
- Make it possible to use CoreDNS as the last route in node-local-dns by @CalleB3 in [#1084](https://github.com/XenitAB/terraform-modules/pulls/1084)
- Bump azurerm provider to v 3.99.0 by @landerss1 in [#1081](https://github.com/XenitAB/terraform-modules/pulls/1081)
- Azuread deprecations introduced in provider v 2.44 by @landerss1 in [#1080](https://github.com/XenitAB/terraform-modules/pulls/1080)
- Remove delegate resource group from namespaces by @phillebaba in [#1078](https://github.com/XenitAB/terraform-modules/pulls/1078)
- Minimum retention days for analytics workspace by @landerss1 in [#1077](https://github.com/XenitAB/terraform-modules/pulls/1077)
- Update Datadog to use workload identities by @phillebaba in [#1076](https://github.com/XenitAB/terraform-modules/pulls/1076)
- Remove provider aws by @landerss1 in [#1073](https://github.com/XenitAB/terraform-modules/pulls/1073)
- Update external-dns to use workload identities for authentication by @phillebaba in [#1069](https://github.com/XenitAB/terraform-modules/pulls/1069)
- Update Spegel to v0.0.20 and move to using chart from spegel-org by @phillebaba in [#1072](https://github.com/XenitAB/terraform-modules/pulls/1072)
- Update cert-manager to use workload identities for authentication by @phillebaba in [#1067](https://github.com/XenitAB/terraform-modules/pulls/1067)
- Use secrets-provider AKS-addon instead of seperate helmchart  by @CalleB3 in [#1058](https://github.com/XenitAB/terraform-modules/pulls/1058)
- Exclude azad-kube-proxy from gatekeeper by @CalleB3 in [#1065](https://github.com/XenitAB/terraform-modules/pulls/1065)
- Make inlude_tenant_name optional by @CalleB3 in [#1063](https://github.com/XenitAB/terraform-modules/pulls/1063)
- Move promtail to install with flux by @CalleB3 in [#1059](https://github.com/XenitAB/terraform-modules/pulls/1059)
- Move azad-kube-proxy to install with flux by @CalleB3 in [#1030](https://github.com/XenitAB/terraform-modules/pulls/1030)
- Update Spegel to v0.0.14 by @phillebaba in [#1044](https://github.com/XenitAB/terraform-modules/pulls/1044)
- Exclude ingress-healthz namespace from gatekeeper by @CalleB3 in [#1040](https://github.com/XenitAB/terraform-modules/pulls/1040)



<!-- generated by git-cliff -->
