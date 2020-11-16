constraints:
  %{ for item in constraints }
  - kind: ${item.kind}
    name: ${item.name}
  %{ endfor }
