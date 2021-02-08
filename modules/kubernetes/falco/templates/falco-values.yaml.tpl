auditLog:
  enabled: false

# Use EBPF instead of kernel module
ebpf:
  enabled: true

falco:
  jsonOutput: true
  jsonIncludeOutputProperty: true
  httpOutput:
    enabled: true
    url: "http://falcosidekick:2801"

  # This should be further explored in the future but seems
  # to be a bug right now with no fix so the solution is sadly
  # to ignore all syscall errors.
  # https://github.com/falcosecurity/falco/issues/1403
  syscallEventDrops:
    actions:
      - log
