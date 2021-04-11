constraints:
  %{~ for item in constraints ~}
  - kind: "${item.kind}"
    name: "${item.name}"
    %{~ if length(item.enforcement_action) > 0 ~}
    enforcementAction: ${item.enforcement_action}
    %{~ endif ~}
    %{~ if (length(item.match.kinds)+length(item.match.namespaces)) > 0 ~}
    match:
      %{~ if length(item.match.namespaces) > 0 ~}
      kinds:
        ${indent(8, chomp(yamlencode(item.match.kinds)))}
      %{~ endif ~}
      %{~ if length(item.match.namespaces) > 0 ~}
      namespaces:
        ${indent(8, chomp(yamlencode(item.match.namespaces)))}
      %{~ endif ~}
    %{~ endif ~}
    %{~ if length(keys(item.parameters)) > 0 ~}
    parameters:
      ${indent(6, chomp(yamlencode(item.parameters)))}
    %{~ endif ~}
  %{~ endfor ~}

mutationExcludedNamespaces:
  %{~ for item in excluded_namespaces ~}
  - "${item}"
  %{~ endfor ~}
assigns:
  %{~ for item in assigns ~}
  - name: "${item.name}"
  %{~ endfor ~}

exclude:
  %{~ for item in excluded_namespaces ~}
  - excludedNamespaces:
      - "${item}"
    processes:
      - "*"
  %{~ endfor ~}
