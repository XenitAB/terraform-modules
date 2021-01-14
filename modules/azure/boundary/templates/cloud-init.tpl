#cloud-config
write_files:
- content: |
    controller {
      name = "main"
      description = "Main Controller"
      database {
        url = "postgresql://${username}:${password}@${server}/${database}"
      }
    }
  path: /etc/boundary-controller.hcl
