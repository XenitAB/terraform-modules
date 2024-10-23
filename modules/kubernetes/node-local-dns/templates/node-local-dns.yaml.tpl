# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Manifest originates from:
# https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/dns/nodelocaldns/nodelocaldns.yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: node-local-dns
  namespace: kube-system
---
apiVersion: v1
kind: Service
metadata:
  name: kube-dns-upstream
  namespace: kube-system
  labels:
    k8s-app: kube-dns
    kubernetes.io/name: "KubeDNSUpstream"
spec:
  ports:
    - name: dns
      port: 53
      protocol: UDP
      targetPort: 53
    - name: dns-tcp
      port: 53
      protocol: TCP
      targetPort: 53
  selector:
    k8s-app: kube-dns
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: node-local-dns
  namespace: kube-system
data:
  Corefile: |
    cluster.local:53 {
        errors
        cache {
                success 9984 30
                denial 9984 5
        }
        reload
        loop
%{ if cilium_enabled }
        bind 0.0.0.0
%{ else }
        bind ${local_dns} ${dns_ip}
%{ endif }

        forward . __PILLAR__CLUSTER__DNS__ {
                force_tcp
        }
        prometheus :9253
%{ if cilium_enabled }
        health :8080
%{ else }
        health ${local_dns}:8080
%{ endif }
        }
    in-addr.arpa:53 {
        errors
        cache 30
        reload
        loop
%{ if cilium_enabled }
        bind 0.0.0.0
%{ else }
        bind ${local_dns} ${dns_ip}
%{ endif }
        forward . __PILLAR__CLUSTER__DNS__ {
                force_tcp
        }
        prometheus :9253
        }
    ip6.arpa:53 {
        errors
        cache 30
        reload
        loop
%{ if cilium_enabled }
        bind 0.0.0.0
%{ else }
        bind ${local_dns} ${dns_ip}
%{ endif }
        forward . __PILLAR__CLUSTER__DNS__ {
                force_tcp
        }
        prometheus :9253
        }
    .:53 {
        errors
        cache {
                prefetch 10
                serve_stale
        }
        reload
        loop
%{ if cilium_enabled }
        bind 0.0.0.0
%{ else }
        bind ${local_dns} ${dns_ip}
%{ endif }
        %{~ if coredns_upstream ~}
        forward . __PILLAR__CLUSTER__DNS__
        %{~ else ~}
        forward . __PILLAR__UPSTREAM__SERVERS__
        %{~ endif ~}
        prometheus :9253
        }
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-local-dns
  namespace: kube-system
  labels:
    k8s-app: node-local-dns
spec:
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 10%
  selector:
    matchLabels:
      k8s-app: node-local-dns
  template:
    metadata:
      labels:
        k8s-app: node-local-dns
      annotations:
%{ if cilium_enabled }
        io.cilium.no-track-port: "53"
%{ endif }
        prometheus.io/port: "9253"
        prometheus.io/scrape: "true"
    spec:
      priorityClassName: system-node-critical
      serviceAccountName: node-local-dns
%{ if cilium_enabled == false }
      hostNetwork: true
%{ endif }
      dnsPolicy: Default # Don't use cluster DNS.
      tolerations:
        - key: "CriticalAddonsOnly"
          operator: "Exists"
        - effect: "NoExecute"
          operator: "Exists"
        - effect: "NoSchedule"
          operator: "Exists"
      containers:
        - name: node-cache
          image: "registry.k8s.io/dns/k8s-dns-node-cache:1.22.20"
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: 25m
              memory: 5Mi
          args:
            [
              "-localip",
              "${local_dns},${dns_ip}",
              "-conf",
              "/etc/Corefile",
              "-upstreamsvc",
              "kube-dns-upstream",
%{ if cilium_enabled }
              "-skipteardown=true",
              "-setupinterface=false",
              "-setupiptables=false"
%{ endif }
            ]
          securityContext:
            privileged: true
          ports:
            - containerPort: 53
              name: dns
              protocol: UDP
            - containerPort: 53
              name: dns-tcp
              protocol: TCP
            - containerPort: 9253
              name: metrics
              protocol: TCP
          livenessProbe:
            httpGet:
%{ if cilium_enabled == false }
              host: ${local_dns}
%{ endif }

              path: /health
              port: 8080
            initialDelaySeconds: 60
            timeoutSeconds: 5
          volumeMounts:
            - mountPath: /run/xtables.lock
              name: xtables-lock
              readOnly: false
            - name: config-volume
              mountPath: /etc/coredns
            - name: kube-dns-config
              mountPath: /etc/kube-dns
      volumes:
        - name: xtables-lock
          hostPath:
            path: /run/xtables.lock
            type: FileOrCreate
        - name: kube-dns-config
          configMap:
            name: coredns
            optional: true
        - name: config-volume
          configMap:
            name: node-local-dns
            items:
              - key: Corefile
                path: Corefile.base
---
# A headless service is a service with a service IP but instead of load-balancing it will return the IPs of our associated Pods.
# We use this to expose metrics to Prometheus.
apiVersion: v1
kind: Service
metadata:
  name: node-local-dns
  namespace: kube-system
  labels:
    k8s-app: node-local-dns
  annotations:
    prometheus.io/port: "9253"
    prometheus.io/scrape: "true"
spec:
  clusterIP: None
  ports:
    - name: metrics
      port: 9253
      targetPort: 9253
  selector:
    k8s-app: node-local-dns
%{ if cilium_enabled }
---
apiVersion: "cilium.io/v2"
kind: CiliumLocalRedirectPolicy
metadata:
  name: "nodelocaldns"
  namespace: kube-system
spec:
  redirectFrontend:
    serviceMatcher:
      serviceName: kube-dns
      namespace: kube-system
  redirectBackend:
    localEndpointSelector:
      matchLabels:
        k8s-app: node-local-dns
    toPorts:
      - port: "53"
        name: dns
        protocol: UDP
      - port: "53"
        name: dns-tcp
        protocol: TCP
%{ endif }