constraints:
  %{ for item in constraints ~}
  - kind: ${item.kind}
    name: ${item.name}
  %{ endfor ~}

exclude:
  %{ for item in exclude ~}
  - excludedNamespaces: ${item.excluded_namespaces}
    processes: ${item.processes}
  %{ endfor ~}

