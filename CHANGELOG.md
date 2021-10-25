# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Calendar Versioning](https://calver.org/).

## Unreleased

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

