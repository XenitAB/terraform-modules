installCRDs: true

%{ if provider == "azure" }
podLabels:
  aadpodidbinding: cert-manager
%{ endif }
