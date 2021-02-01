auditLog:
  enabled: true

ebpf:
  enabled: true

falco:
  jsonOutput: true
  jsonIncludeOutputProperty: true
  httpOutput:
    enabled: true
    url: "http://falcosidekick:2801"
