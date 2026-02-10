# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## 2026.02.01

### ⛓️‍💥 Breaking Changes
- Feat!: add support for ArgoCD by @landerss1 in [#1339](https://github.com/XenitAB/terraform-modules/pulls/1339)

### 🚀 New Features
- Feat: adding max vm map count to an increased default value for all n… by @yabracadabra in [#1401](https://github.com/XenitAB/terraform-modules/pulls/1401)
- Feat: move flux to install with argo & helm by @CalleB3 in [#1370](https://github.com/XenitAB/terraform-modules/pulls/1370)
- Feat: switch Argo hub from PAT to Github App auth by @CalleB3 in [#1369](https://github.com/XenitAB/terraform-modules/pulls/1369)
- Feat: Name override aks core keyvault value by @optocoupler in [#1366](https://github.com/XenitAB/terraform-modules/pulls/1366)
- Feat: name override feature by @optocoupler in [#1365](https://github.com/XenitAB/terraform-modules/pulls/1365)
- Feat: add tenant support for ArgoCD by @landerss1 in [#1357](https://github.com/XenitAB/terraform-modules/pulls/1357)
- Feat: add support for external secrets operator by @landerss1 in [#1356](https://github.com/XenitAB/terraform-modules/pulls/1356)
- Feat: separate subnets per node pool by @landerss1 in [#1350](https://github.com/XenitAB/terraform-modules/pulls/1350)
- Feat: enable argocd metrics by @landerss1 in [#1347](https://github.com/XenitAB/terraform-modules/pulls/1347)
- Feat: enable tuning of vital ArgoCD parameters by @landerss1 in [#1344](https://github.com/XenitAB/terraform-modules/pulls/1344)
- Feat: giving flux acr permissions by @optocoupler in [#1335](https://github.com/XenitAB/terraform-modules/pulls/1335)
- Feat: make it possible to enable ACR admin account by @landerss1 in [#1334](https://github.com/XenitAB/terraform-modules/pulls/1334)



### 🐛 Bug Fixes
- Fix: finalizers for argocd by @yabracadabra in [#1403](https://github.com/XenitAB/terraform-modules/pulls/1403)
- Fix: Remove node pool name validation by @yabracadabra in [#1396](https://github.com/XenitAB/terraform-modules/pulls/1396)
- Fix: Add possibility to add tags on AKS resource by @CalleB3 in [#1391](https://github.com/XenitAB/terraform-modules/pulls/1391)
- Fix: change chart name to datadog-operator by @yabracadabra in [#1388](https://github.com/XenitAB/terraform-modules/pulls/1388)
- Fix: add default for keyvault_name_override by @CalleB3 in [#1373](https://github.com/XenitAB/terraform-modules/pulls/1373)
- Fix: increase acceptable header size for argo ingress by @CalleB3 in [#1367](https://github.com/XenitAB/terraform-modules/pulls/1367)
- Fix: Upgrade Karpenter and add nodeClassRef parameters by @CalleB3 in [#1364](https://github.com/XenitAB/terraform-modules/pulls/1364)
- Fix: restore flux related policies by @landerss1 in [#1349](https://github.com/XenitAB/terraform-modules/pulls/1349)
- Fix: linkerd chart indentation errors by @landerss1 in [#1348](https://github.com/XenitAB/terraform-modules/pulls/1348)
- Fix: add grafana-k8s-monitoring as a gatekeeper excluded namespace by @landerss1 in [#1342](https://github.com/XenitAB/terraform-modules/pulls/1342)
- Fix: linkerd template indentation and gatekeeper exclusion by @landerss1 in [#1341](https://github.com/XenitAB/terraform-modules/pulls/1341)
- Fix: broken grafana-k8s-monitoring template by @landerss1 in [#1340](https://github.com/XenitAB/terraform-modules/pulls/1340)



### ⚙️ Miscellaneous
- Fix: Fixing temporary required name by @yabracadabra in [#1402](https://github.com/XenitAB/terraform-modules/pulls/1402)
- Chore: upgrade of module components by @yabracadabra in [#1399](https://github.com/XenitAB/terraform-modules/pulls/1399)
- Chore: adding additional nodepool osdisksize option by @optocoupler in [#1398](https://github.com/XenitAB/terraform-modules/pulls/1398)
- Chore: Rabbitmq operator bitnami migration by @optocoupler in [#1384](https://github.com/XenitAB/terraform-modules/pulls/1384)
- Fix: Revert remove node pool name validation by @CalleB3 in [#1397](https://github.com/XenitAB/terraform-modules/pulls/1397)
- Chore: Upgrade trivy and fix workload identity for scans by @CalleB3 in [#1394](https://github.com/XenitAB/terraform-modules/pulls/1394)
- Chore: deprecate Telepresence module by @yabracadabra in [#1389](https://github.com/XenitAB/terraform-modules/pulls/1389)
- Chore: bump valid k8s versions for upgrading by @CalleB3 in [#1386](https://github.com/XenitAB/terraform-modules/pulls/1386)
- Chore: upgrade of vpa and vpa-recommender and goldilocks by @yabracadabra in [#1385](https://github.com/XenitAB/terraform-modules/pulls/1385)
- Chore: upgrade velero helm to 11.0.0 and velero azure plugin image to 1.13.0 by @yabracadabra in [#1383](https://github.com/XenitAB/terraform-modules/pulls/1383)
- Chore: migrating away from bitnami and bumping versions by @optocoupler in [#1378](https://github.com/XenitAB/terraform-modules/pulls/1378)
- Chore: bump terraform-linters/setup-tflint from 4 to 6 by @yabracadabra in [#1374](https://github.com/XenitAB/terraform-modules/pulls/1374)
- Chore: update nginx helm version to 4.13.3 by @yabracadabra in [#1377](https://github.com/XenitAB/terraform-modules/pulls/1377)
- Chore: version control-plane-logs to 0.46.0 by @yabracadabra in [#1376](https://github.com/XenitAB/terraform-modules/pulls/1376)
- Chore: versionbump cert-manager 1.18.2 by @yabracadabra in [#1375](https://github.com/XenitAB/terraform-modules/pulls/1375)
- Chore: External dns bitnami migration by @optocoupler in [#1372](https://github.com/XenitAB/terraform-modules/pulls/1372)
- Chore: Bump argocd helm version by @optocoupler in [#1368](https://github.com/XenitAB/terraform-modules/pulls/1368)
- Chore: bumping karpenter version by @optocoupler in [#1362](https://github.com/XenitAB/terraform-modules/pulls/1362)
- Chore: remove life-cycle management on fluxcd tenant git files by @landerss1 in [#1359](https://github.com/XenitAB/terraform-modules/pulls/1359)
- Chore: upgrade datadog by @landerss1 in [#1358](https://github.com/XenitAB/terraform-modules/pulls/1358)
- Chore: upgrade supported k8s versions by @landerss1 in [#1353](https://github.com/XenitAB/terraform-modules/pulls/1353)
- Chore: upgrade karpenter to 1.4.0 by @landerss1 in [#1352](https://github.com/XenitAB/terraform-modules/pulls/1352)
- Chore: upgrade argocd chart to 8.0.6 by @landerss1 in [#1345](https://github.com/XenitAB/terraform-modules/pulls/1345)
- Chore: upgrade node-ttl to v0.0.9 by @landerss1 in [#1333](https://github.com/XenitAB/terraform-modules/pulls/1333)
- Chore: upgrade git-auth-proxy to latest version by @landerss1 in [#1330](https://github.com/XenitAB/terraform-modules/pulls/1330)
- Chore: upgrade node-ttl to latest version by @landerss1 in [#1328](https://github.com/XenitAB/terraform-modules/pulls/1328)
- Chore: upgrade falco charts to latest version by @landerss1 in [#1327](https://github.com/XenitAB/terraform-modules/pulls/1327)
- Chore: upgrade reloader to latest version by @landerss1 in [#1326](https://github.com/XenitAB/terraform-modules/pulls/1326)
- Chore: upgrade vpa charts to latest by @landerss1 in [#1325](https://github.com/XenitAB/terraform-modules/pulls/1325)
- Chore: upgrade trivy module to latest by @landerss1 in [#1322](https://github.com/XenitAB/terraform-modules/pulls/1322)



## [2025.04.1](https://github.com/XenitAB/terraform-modules/releases/tag/2025.04.1)

### ⛓️‍💥 Breaking Changes
- Fix!: resolve dependency and timing issues when applying aks-core module in an empty cluster by @landerss1 in [#1240](https://github.com/XenitAB/terraform-modules/pulls/1240)



### 🚀 New Features
- Feat: feature for node affinity by @optocoupler in [#1321](https://github.com/XenitAB/terraform-modules/pulls/1321)
- Feat: add support for nsg rule destination/source_address_prefixes by @landerss1 in [#1319](https://github.com/XenitAB/terraform-modules/pulls/1319)
- Feat: add delegations block to subnet by @landerss1 in [#1318](https://github.com/XenitAB/terraform-modules/pulls/1318)
- Feat: add support for KEDA autoscaling by @landerss1 in [#1304](https://github.com/XenitAB/terraform-modules/pulls/1304)
- Feat: add support for removing spot instances taints in clusters that are automated to start/stop by @landerss1 in [#1303](https://github.com/XenitAB/terraform-modules/pulls/1303)
- Feat: adding an ingress so we can easily alert for cluster health status by @optocoupler in [#1302](https://github.com/XenitAB/terraform-modules/pulls/1302)
- Feat: upgrade Karpenter and enable spotToSpotConsolidation by @CalleB3 in [#1295](https://github.com/XenitAB/terraform-modules/pulls/1295)
- Feat: add support for Rabbitmq operator by @landerss1 in [#1291](https://github.com/XenitAB/terraform-modules/pulls/1291)
- Feat: adding support for ECK by @optocoupler in [#1288](https://github.com/XenitAB/terraform-modules/pulls/1288)
- Feat: allow cert-manager to run on spot nodes by @landerss1 in [#1281](https://github.com/XenitAB/terraform-modules/pulls/1281)
- Feat: allow scheduling ingress-nginx on spot nodes by @landerss1 in [#1280](https://github.com/XenitAB/terraform-modules/pulls/1280)
- Feat: make ingress-nginx replicas configurable by @landerss1 in [#1279](https://github.com/XenitAB/terraform-modules/pulls/1279)
- Feat: add support for LitmusChaos by @landerss1 in [#1260](https://github.com/XenitAB/terraform-modules/pulls/1260)
- Feat: Add option to set NSG rules by @CalleB3 in [#1251](https://github.com/XenitAB/terraform-modules/pulls/1251)
- Feat: add envoy gateway by @optocoupler in [#1236](https://github.com/XenitAB/terraform-modules/pulls/1236)
- Feat: add support for specifying parameters for additional storage classes by @landerss1 in [#1248](https://github.com/XenitAB/terraform-modules/pulls/1248)
- Feat: add support for popeye k8s linter by @landerss1 in [#1239](https://github.com/XenitAB/terraform-modules/pulls/1239)
- Feat: add support for karpenter autoscaling by @landerss1 in [#1235](https://github.com/XenitAB/terraform-modules/pulls/1235)
- Feat: Upgrade Linkerd-CNI and CRDs by @CalleB3 in [#1231](https://github.com/XenitAB/terraform-modules/pulls/1231)
- Feat: add option to use Azure CNI with Cilium by @CalleB3 in [#1142](https://github.com/XenitAB/terraform-modules/pulls/1142)
- Feat: add support for Nginx Gateway Fabric by @landerss1 in [#1228](https://github.com/XenitAB/terraform-modules/pulls/1228)
- Feat: add support for Gateway API by @landerss1 in [#1226](https://github.com/XenitAB/terraform-modules/pulls/1226)
- Feat:  metrics for flux system by @optocoupler in [#1200](https://github.com/XenitAB/terraform-modules/pulls/1200)
- Feat: Move azad-kube-proxy to aks-core and use SecretProviderClass by @CalleB3 in [#1196](https://github.com/XenitAB/terraform-modules/pulls/1196)
- Feat: improved grafana agent configuration by @landerss1 in [#1192](https://github.com/XenitAB/terraform-modules/pulls/1192)
- Feat: add gateway_transit option to peering_config by @landerss1 in [#1189](https://github.com/XenitAB/terraform-modules/pulls/1189)
- Feat: changing the alerts interval evaluation time by @optocoupler in [#1184](https://github.com/XenitAB/terraform-modules/pulls/1184)
- Feat: adding alerting for flux by @optocoupler in [#1182](https://github.com/XenitAB/terraform-modules/pulls/1182)
- Feat: fixing the memory consumption issues by @optocoupler in [#1180](https://github.com/XenitAB/terraform-modules/pulls/1180)
- Feat: disabling opencost by @optocoupler in [#1174](https://github.com/XenitAB/terraform-modules/pulls/1174)
- Feat: adding filtering for namespaces for grafana k8s chart by @optocoupler in [#1166](https://github.com/XenitAB/terraform-modules/pulls/1166)
- Feat: add initial support for automation alerts by @landerss1 in [#1167](https://github.com/XenitAB/terraform-modules/pulls/1167)
- Feat: Adding Grafana Cloud k8s monitoring stack by @optocoupler in [#1161](https://github.com/XenitAB/terraform-modules/pulls/1161)
- Feat: create entra group for access to automation account operators by @landerss1 in [#1162](https://github.com/XenitAB/terraform-modules/pulls/1162)



### 🐛 Bug Fixes
- Fix: consolidation attempt rework by @optocoupler in [#1314](https://github.com/XenitAB/terraform-modules/pulls/1314)
- Fix: typo by @optocoupler in [#1312](https://github.com/XenitAB/terraform-modules/pulls/1312)
- Fix: not a good solution when there are multiple tennats so instead w… by @optocoupler in [#1310](https://github.com/XenitAB/terraform-modules/pulls/1310)
- Fix: flux monitoring for production clusters by @optocoupler in [#1309](https://github.com/XenitAB/terraform-modules/pulls/1309)
- Fix: removing all tenant namespaces from metrics and logs by @optocoupler in [#1308](https://github.com/XenitAB/terraform-modules/pulls/1308)
- Fix: nginx templating syntax by @CalleB3 in [#1307](https://github.com/XenitAB/terraform-modules/pulls/1307)
- Fix: only create nginx_ingress_healthz for public ingress by @CalleB3 in [#1305](https://github.com/XenitAB/terraform-modules/pulls/1305)
- Fix: moving envoy out of azure-policy module by @optocoupler in [#1300](https://github.com/XenitAB/terraform-modules/pulls/1300)
- Fix: aks validation should allow no nodepools elements by @landerss1 in [#1297](https://github.com/XenitAB/terraform-modules/pulls/1297)
- Fix: make network contributor role work with cilium by @landerss1 in [#1296](https://github.com/XenitAB/terraform-modules/pulls/1296)
- Fix: add required network contributor role at subscription level by @landerss1 in [#1293](https://github.com/XenitAB/terraform-modules/pulls/1293)
- Fix: fixing a bad copy/paste for the folder structure of the new ECK module by @optocoupler in [#1290](https://github.com/XenitAB/terraform-modules/pulls/1290)
- Fix: bad copy pasta by @optocoupler in [#1289](https://github.com/XenitAB/terraform-modules/pulls/1289)
- Fix: flux wrongful use of include_tenant_name by @CalleB3 in [#1287](https://github.com/XenitAB/terraform-modules/pulls/1287)
- Fix: bad parsing of list by @optocoupler in [#1286](https://github.com/XenitAB/terraform-modules/pulls/1286)
- Fix: indentation of variable by @optocoupler in [#1285](https://github.com/XenitAB/terraform-modules/pulls/1285)
- Fix: Upgrade Velero and plugin to support Workload Identity by @CalleB3 in [#1266](https://github.com/XenitAB/terraform-modules/pulls/1266)
- Fix: the temporary disk setting causes issues with nodepools by @optocoupler in [#1265](https://github.com/XenitAB/terraform-modules/pulls/1265)
- Fix: defender-shenanigans by @optocoupler in [#1258](https://github.com/XenitAB/terraform-modules/pulls/1258)
- Fix: gateway_envoy seemless integration by @optocoupler in [#1254](https://github.com/XenitAB/terraform-modules/pulls/1254)
- Fix: ignore metadata changes for flux namespace by @landerss1 in [#1246](https://github.com/XenitAB/terraform-modules/pulls/1246)
- Fix: add required name label to ingress-nginx namespace by @landerss1 in [#1244](https://github.com/XenitAB/terraform-modules/pulls/1244)
- Fix: use kubernets datasource to retrieve aks identity by @landerss1 in [#1243](https://github.com/XenitAB/terraform-modules/pulls/1243)
- Fix: disable linkerd-cni by @CalleB3 in [#1233](https://github.com/XenitAB/terraform-modules/pulls/1233)
- Fix: Add reloader annotation to azad-kube-proxy by @CalleB3 in [#1217](https://github.com/XenitAB/terraform-modules/pulls/1217)
- Fix: add flux notification provider by @CalleB3 in [#1222](https://github.com/XenitAB/terraform-modules/pulls/1222)
- Fix: add flux notification-controller by @CalleB3 in [#1220](https://github.com/XenitAB/terraform-modules/pulls/1220)
- Fix: adding namespaced discovery by @optocoupler in [#1219](https://github.com/XenitAB/terraform-modules/pulls/1219)
- Fix: add end_date to azad-proxy azuread_application_password by @CalleB3 in [#1216](https://github.com/XenitAB/terraform-modules/pulls/1216)
- Fix: base64 encode private key for flux GitHub tenants by @landerss1 in [#1214](https://github.com/XenitAB/terraform-modules/pulls/1214)
- Fix: glux bootstrap not working for GitHub tenants by @landerss1 in [#1213](https://github.com/XenitAB/terraform-modules/pulls/1213)
- Fix: git-auth-proxy config should not have project specified for GitH… by @landerss1 in [#1212](https://github.com/XenitAB/terraform-modules/pulls/1212)
- Fix: wrong GitHub application id attribute provided in template by @landerss1 in [#1211](https://github.com/XenitAB/terraform-modules/pulls/1211)
- Fix: flux project name is null for GitHub tenants by @landerss1 in [#1209](https://github.com/XenitAB/terraform-modules/pulls/1209)
- Fix: don't create secret for git-auth-proxy if tenant is not using flux by @landerss1 in [#1208](https://github.com/XenitAB/terraform-modules/pulls/1208)
- Fix: don't create flux tenant artifacts if flux isn't enabled by @landerss1 in [#1207](https://github.com/XenitAB/terraform-modules/pulls/1207)
- Fix: create azure policy regardless of flux config by @landerss1 in [#1206](https://github.com/XenitAB/terraform-modules/pulls/1206)
- Fix: some tenants don't have gatekeeper installed/enabled by @optocoupler in [#1202](https://github.com/XenitAB/terraform-modules/pulls/1202)
- Fix: dont install unused CRDs by @CalleB3 in [#1197](https://github.com/XenitAB/terraform-modules/pulls/1197)
- Fix: grafana alloy using wrong location short name by @landerss1 in [#1188](https://github.com/XenitAB/terraform-modules/pulls/1188)
- Fix: telepresence deployment error by @landerss1 in [#1187](https://github.com/XenitAB/terraform-modules/pulls/1187)
- Fix: Revert Exclude ambassador namespace" by @landerss1 in [#1186](https://github.com/XenitAB/terraform-modules/pulls/1186)
- Fix: Exclude ambassador namespace by @CalleB3 in [#1185](https://github.com/XenitAB/terraform-modules/pulls/1185)
- Fix: wrong location name forces replacement of automation resources by @landerss1 in [#1179](https://github.com/XenitAB/terraform-modules/pulls/1179)
- Fix: in some clusters we dont use gatekeeper-config by @optocoupler in [#1175](https://github.com/XenitAB/terraform-modules/pulls/1175)
- Fix: incorrect naming of input variable by @landerss1 in [#1170](https://github.com/XenitAB/terraform-modules/pulls/1170)



### 🚜 Refactor
- Refactor: remove azad-kube-proxy module by @optocoupler in [#1224](https://github.com/XenitAB/terraform-modules/pulls/1224)
- Refactor: associate AKS default NSG with vnet subnet  by @landerss1 in [#1237](https://github.com/XenitAB/terraform-modules/pulls/1237)
- Refactor: use Microsoft provider for Azure DevOps by @landerss1 in [#1177](https://github.com/XenitAB/terraform-modules/pulls/1177)
- Refactor: explicitly set AKS SKU tier and node count by @landerss1 in [#1168](https://github.com/XenitAB/terraform-modules/pulls/1168)



### ⚙️ Miscellaneous
- Chore: upgrade nginx controller to latest version by @landerss1 in [#1317](https://github.com/XenitAB/terraform-modules/pulls/1317)
- Chore: user friendlines for a newtork policy name by @optocoupler in [#1315](https://github.com/XenitAB/terraform-modules/pulls/1315)
- Chore: consolidating all monitoring resources to avoid CRD issues by @optocoupler in [#1311](https://github.com/XenitAB/terraform-modules/pulls/1311)
- Chore: bump azurerm provider to v 4.19.0 by @landerss1 in [#1299](https://github.com/XenitAB/terraform-modules/pulls/1299)
- Chore: upgrading grafana k8s monitoring chart by @optocoupler in [#1283](https://github.com/XenitAB/terraform-modules/pulls/1283)
- Chore: Update cluster components by @landerss1 in [#1267](https://github.com/XenitAB/terraform-modules/pulls/1267)
- Chore: update list of supported VM skus by @landerss1 in [#1277](https://github.com/XenitAB/terraform-modules/pulls/1277)
- Chore: bump orhun/git-cliff-action from 3 to 4 by @landerss1 in [#1165](https://github.com/XenitAB/terraform-modules/pulls/1165)
- Chore: bumping kubectl provider version by @optocoupler in [#1257](https://github.com/XenitAB/terraform-modules/pulls/1257)
- Chore: Upgrade azad-kube-proxy to 0.0.48 by @CalleB3 in [#1234](https://github.com/XenitAB/terraform-modules/pulls/1234)
- Chore: Upgrade Azurerm to 4.7.0 by @CalleB3 in [#1230](https://github.com/XenitAB/terraform-modules/pulls/1230)
- Chore: update cert-manager CRDs to v1.15.3 by @landerss1 in [#1227](https://github.com/XenitAB/terraform-modules/pulls/1227)
- Chore!: bump flux provider to v1.4.0 by @landerss1 in [#1203](https://github.com/XenitAB/terraform-modules/pulls/1203)
- Chore: Update Ingress-nginx, Cert-manager and external-dns by @CalleB3 in [#1191](https://github.com/XenitAB/terraform-modules/pulls/1191)
- Chore: bump ytanikin/PRConventionalCommits from 1.2.0 to 1.3.0 by @landerss1 in [#1190](https://github.com/XenitAB/terraform-modules/pulls/1190)
- Ci: bump terraform-docs version to v 0.19.0 by @landerss1 in [#1193](https://github.com/XenitAB/terraform-modules/pulls/1193)
- Chore: bump peter-evans/create-pull-request from 4 to 7 by @landerss1 in [#1172](https://github.com/XenitAB/terraform-modules/pulls/1172)
- Chore: upgrade falco-exporter chart to 0.12.1 by @landerss1 in [#1173](https://github.com/XenitAB/terraform-modules/pulls/1173)



### 📚 Documentation



## [2024.08.1](https://github.com/XenitAB/terraform-modules/releases/tag/2024.08.1)

### 🚀 New Features
- Feat: prevent destruction of tenant namespaces by @landerss1 in [#1158](https://github.com/XenitAB/terraform-modules/pulls/1158)
- Feat: adding grafana alloy module for k8s by @optocoupler in [#1156](https://github.com/XenitAB/terraform-modules/pulls/1156)
- Feat: make service_principal_all_owner_name optional by @landerss1 in [#1139](https://github.com/XenitAB/terraform-modules/pulls/1139)
- Feat: add support for Temporary kubelet disk type by @landerss1 in [#1153](https://github.com/XenitAB/terraform-modules/pulls/1153)
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
- Feat(azure/governance-regional): add output of key vault names by @landerss1 in [#1045](https://github.com/XenitAB/terraform-modules/pulls/1045)
- Chore: upgrade hashicorp/setup-terraform from 2 to 3 by @landerss1 in [#1042](https://github.com/XenitAB/terraform-modules/pulls/1042)
- Chore: upgrade terraform-linters/setup-tflint from 3 to 4 by @landerss1 in [#1034](https://github.com/XenitAB/terraform-modules/pulls/1034)
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
