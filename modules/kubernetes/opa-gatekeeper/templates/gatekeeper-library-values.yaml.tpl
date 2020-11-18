constraints:
  %{~ for item in constraints ~}
  - kind: "${item.kind}"
    name: "${item.name}"
    parameters:
      ${indent(6, yamlencode(item.parameters))}
  %{~ endfor ~}
exclude:
  %{~ for item in exclude ~}
  - excludedNamespaces:
    %{~ for item in item.excluded_namespaces ~}
      - "${item}"
    %{~ endfor ~}
    processes:
    %{~ for item in item.processes ~}
      - "${item}"
    %{~ endfor ~}
  %{~ endfor ~}
