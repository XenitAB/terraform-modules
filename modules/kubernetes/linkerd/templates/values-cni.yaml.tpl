namespace: linkerd-cni
installNamespace: false
tolerations:
  - operator: "Exists"

cniPluginImage: "ghcr.io/linkerd/cni-plugin"
priorityClassName: platform-high

extraInitContainers:
  - name: wait-for-other-cni
    image: busybox:1.33
    command:
      - /bin/sh
      - -xc
      - |
        for i in $(seq 1 180); do
          test -f /host/etc/cni/net.d/05-cilium.conf && exit 0
          sleep 1
        done
        exit 1
    volumeMounts:
      - mountPath: /host/etc/cni/net.d
        name: cni-net-dir
