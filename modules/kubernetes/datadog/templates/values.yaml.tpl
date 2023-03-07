site: ${datadog_site}
clusterName: ${location}-${environment}
containerInclude: ${container_filter_include}
apmIgnoreResources: ${apm_ignore_resources}
environment: ${environment}
datadog-crds:
  migration:
    datadogAgents:
      version: "v2alpha1"