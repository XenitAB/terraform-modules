priorityClassName: platform-high

tolerations:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
  - operator: Exists
