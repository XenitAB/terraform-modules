docker:
  enabled: false

fakeEventGenerator:
  enabled: true
  args:
    - run
    - --loop
    - ^syscall
  replicas: 1

auditLog:
  enabled: true

falco:
  jsonOutput: true
  jsonIncludeOutputProperty: true
  httpOutput:
    enabled: true
    url: "http://falcosidekick:2801/"
