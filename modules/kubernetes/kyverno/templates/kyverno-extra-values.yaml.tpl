excludedNamespaces:
  %{~ for item in excluded_namespaces ~}
  - "${item}"
  %{~ endfor ~}
