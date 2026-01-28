---
# GatewayClass - Defines the controller that will manage Gateway resources
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
  description: "${tenant_name} ${environment} gateway class managed by Xenit"
---
# ClientTrafficPolicy for HTTP to HTTPS redirect
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: http-to-https-redirect
  namespace: envoy-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: GatewayClass
    name: ${tenant_name}-${environment}
  # Redirect HTTP to HTTPS
  http1:
    preserveHeaderCase: true
  http2:
    initialConnectionWindowSize: 1048576
    initialStreamWindowSize: 65536
  # HTTP to HTTPS redirect
  enableHTTPSRedirect: true
---
# SecurityPolicy for rate limiting, CORS, JWT, and security headers
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: default-security-policy
  namespace: envoy-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: GatewayClass
    name: ${tenant_name}-${environment}
  # Rate limiting to prevent abuse
  rateLimiting:
    type: Global
    global:
      rules:
        # Global rate limit: 1000 requests per minute per IP
        - clientSelectors:
            - headers:
                - name: X-Forwarded-For
                  type: Distinct
          limit:
            requests: 1000
            unit: Minute
        # Path-specific limits for sensitive endpoints
        - clientSelectors:
            - headers:
                - name: ":path"
                  value: "/api/auth/.*"
                  type: RegularExpression
          limit:
            requests: 20
            unit: Minute
        # General API rate limit
        - clientSelectors:
            - headers:
                - name: ":path"
                  value: "/api/.*"
                  type: RegularExpression
          limit:
            requests: 100
            unit: Minute
  # CORS policy (customize per your needs)
  cors:
    allowOrigins:
      - "*"  # IMPORTANT: Change this to your specific domains in production
    allowMethods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
      - OPTIONS
    allowHeaders:
      - "*"
    exposeHeaders:
      - Content-Length
      - Content-Type
    maxAge: 24h
    allowCredentials: false
---
# BackendTrafficPolicy for security headers and timeouts
# NOTE: This targets GatewayClass by default. For production use, change the targetRef
# to point to a specific Gateway resource (kind: Gateway, name: <gateway-name>, namespace: <namespace>)
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: BackendTrafficPolicy
metadata:
  name: security-headers
  namespace: envoy-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: GatewayClass
    name: ${tenant_name}-${environment}
  # Timeout configuration
  timeout:
    tcp:
      connectTimeout: 10s
    http:
      requestTimeout: 60s
      connectionIdleTimeout: 300s
  # Security response headers
  headers:
    response:
      add:
        - name: X-Content-Type-Options
          value: nosniff
        - name: X-XSS-Protection
          value: "1; mode=block"
        - name: X-Frame-Options
          value: SAMEORIGIN
        - name: Strict-Transport-Security
          value: "max-age=31536000; includeSubDomains"
        - name: Content-Security-Policy
          value: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
        - name: Referrer-Policy
          value: strict-origin-when-cross-origin
        - name: Permissions-Policy
          value: "geolocation=(), microphone=(), camera=()"
      remove:
        - Server
        - X-Powered-By
