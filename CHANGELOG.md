# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Calendar Versioning](https://calver.org/).

## Unreleased

### Added

- [#416](https://github.com/XenitAB/terraform-modules/pull/416) Enable Prometheus pod monitoring for azad-kube-proxy.
- [#420](https://github.com/XenitAB/terraform-modules/pull/420) Add support for New Relic metrics and log exporting. This feature is optional opt-in and will have no effect on current deployments.

### Changed

- [#415](https://github.com/XenitAB/terraform-modules/pull/415) Migrate from azdo-proxy to git-auth-proxy and update GitHub FluxV2 module to work with git-auth-proxy.
- [#418](https://github.com/XenitAB/terraform-modules/pull/418) [Breaking] Update the Flux provider version to 0.4.0. Check the [provider release](https://github.com/fluxcd/terraform-provider-flux/blob/main/CHANGELOG.md#040) for migration instructions.
- [#423](https://github.com/XenitAB/terraform-modules/pull/423) Fix enabling monitors from aks-core and eks-core.
