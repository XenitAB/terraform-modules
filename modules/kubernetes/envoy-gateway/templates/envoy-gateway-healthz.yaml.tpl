---
# Gateway with a dedicated HTTPS listener for the health check endpoint.
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: health-gateway
  namespace: envoy-gateway
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
spec:
  gatewayClassName: ${tenant_name}-${environment}
  listeners:
    - name: health-https
      protocol: HTTPS
      port: 443
      hostname: "health.${healthz_hostname}"
      tls:
        mode: Terminate
        certificateRefs:
          - name: healthz-gateway-secret
      allowedRoutes:
        namespaces:
          from: Same
---
# Direct response — Envoy itself returns 200 OK without proxying anywhere.
# If the proxy pod is down the request fails, giving the same "is the
# gateway alive?" signal as the old ingress-nginx /healthz endpoint.
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: healthz-direct-response
  namespace: envoy-gateway
spec:
  directResponse:
    statusCode: 200
    body:
      type: Inline
      inline: "OK"
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: healthz
  namespace: envoy-gateway
spec:
  parentRefs:
    - name: health-gateway
      namespace: envoy-gateway
  hostnames:
    - "health.${healthz_hostname}"
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /healthz
      filters:
        - type: ExtensionRef
          extensionRef:
            group: gateway.envoyproxy.io
            kind: HTTPRouteFilter
            name: healthz-direct-response
%{~ if length(healthz_whitelist_ips) > 0 ~}

---

# IP allowlist — equivalent to the nginx whitelist-source-range annotation.
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: healthz-ip-allowlist
  namespace: envoy-gateway
spec:
  targetRefs:
    - group: gateway.networking.k8s.io
      kind: HTTPRoute
      name: healthz
  authorization:
    defaultAction: Deny
    rules:
      - name: allow-monitoring
        action: Allow
        principal:
          clientCIDRs:
%{~ for cidr in flatten([for entry in healthz_whitelist_ips : split(",", entry)]) }
            - "${trimspace(cidr)}"
%{~ endfor }
%{~ endif ~}
