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
        bind ${local_dns} ${dns_ip}
        forward . __PILLAR__CLUSTER__DNS__ {
                force_tcp
        }
        prometheus :9253
        health ${local_dns}:8080
        }
    in-addr.arpa:53 {
        errors
        cache 30
        reload
        loop
        bind ${local_dns} ${dns_ip}
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
        bind ${local_dns} ${dns_ip}
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
        bind ${local_dns} ${dns_ip}
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
        prometheus.io/port: "9253"
        prometheus.io/scrape: "true"
    spec:
      priorityClassName: system-node-critical
      serviceAccountName: node-local-dns
      hostNetwork: true
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
          image: "registry.k8s.io/dns/k8s-dns-node-cache:1.23.1"
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
              host: ${local_dns}
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
