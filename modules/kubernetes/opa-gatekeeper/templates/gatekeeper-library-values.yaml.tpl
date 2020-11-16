constraints:
  %{ for item in constraints ~}
  - kind: ${item.kind}
    name: ${item.name}
  %{ endfor ~}

exclude:
  %{ for item in exclude ~}
  - excludedNamespaces:
      ${yamlencode(item.excluded_namespaces)}
    processes:
      ${yamlencode(item.processes)}
  %{ endfor ~}

