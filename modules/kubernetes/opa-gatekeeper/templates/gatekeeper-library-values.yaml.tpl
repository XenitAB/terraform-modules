constraints:
  %{~ for item in constraints ~}
  - kind: "${item.kind}"
    name: "${item.name}"
    %{~ if (length(item.match.kinds)+length(item.match.namespaces)) > 0 ~}
    match:
      kinds:
        ${indent(8, chomp(yamlencode(item.match.kinds)))}
      %{~ if length(item.match.namespaces) == 1 && item.match.namespaces[0] != "*" ~}
      namespaces:
        ${indent(8, chomp(yamlencode(item.match.namespaces)))}
      %{~ endif ~}
    %{~ endif ~}
    %{~ if length(keys(item.parameters)) > 0 ~}
    parameters:
      ${indent(6, chomp(yamlencode(item.parameters)))}
    %{~ endif ~}
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
