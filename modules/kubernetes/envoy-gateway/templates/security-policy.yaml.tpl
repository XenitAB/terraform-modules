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
  # Security headers
  extAuth:
    headersToBackend:
      - X-Request-Id
      - X-Forwarded-For
---
# EnvoyPatchPolicy for adding security headers and hardening
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyPatchPolicy
metadata:
  name: security-headers
  namespace: envoy-gateway
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: GatewayClass
    name: ${tenant_name}-${environment}
  type: JSONPatch
  jsonPatches:
    # Add security response headers
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/response_headers_to_add"
        value:
          # Prevent MIME type sniffing
          - header:
              key: "X-Content-Type-Options"
              value: "nosniff"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Enable XSS protection
          - header:
              key: "X-XSS-Protection"
              value: "1; mode=block"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Prevent clickjacking
          - header:
              key: "X-Frame-Options"
              value: "SAMEORIGIN"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Strict Transport Security (HSTS)
          - header:
              key: "Strict-Transport-Security"
              value: "max-age=31536000; includeSubDomains"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Content Security Policy
          - header:
              key: "Content-Security-Policy"
              value: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Referrer Policy
          - header:
              key: "Referrer-Policy"
              value: "strict-origin-when-cross-origin"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
          # Permissions Policy
          - header:
              key: "Permissions-Policy"
              value: "geolocation=(), microphone=(), camera=()"
            append_action: OVERWRITE_IF_EXISTS_OR_ADD
    # Remove server header to avoid information disclosure
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/response_headers_to_remove"
        value:
          - "Server"
          - "X-Powered-By"
    # Configure request buffer limits
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/stream_idle_timeout"
        value: "300s"
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/request_timeout"
        value: "60s"
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/request_headers_timeout"
        value: "10s"
    # Limit request body size (10MB default, adjust as needed)
    - type: "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
      name: envoy.filters.network.http_connection_manager
      operation:
        op: add
        path: "/max_request_headers_kb"
        value: 96  # 96KB for request headers (like nginx large_client_header_buffers)
