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
  # Whether to output events in json or text
  #jsonOutput: false
  # Minimum rule priority level to load and run. All rules having a
  # priority more severe than this level will be loaded/run.  Can be one
  # of "emergency", "alert", "critical", "error", "warning", "notice",
  # "info", "debug".
  #priority: debug
