docker:
  enabled: false

fakeEventGenerator:
  enabled: false
  args:
    - run
    - --loop
    - ^syscall
  replicas: 1

#auditLog:
#  enabled: false
#  dynamicBackend:
#    # true here configures an AuditSink who will receive the K8s audit logs
#    enabled: false
#    # define if auditsink client config should point to a fixed url, not the
#    # default webserver service
#    url: ""

falco:
  jsonOutput: true
  jsonIncludeOutputProperty: true
  httpOutput:
    enabled: true
    url: "http://falcosidekick:2801/"
