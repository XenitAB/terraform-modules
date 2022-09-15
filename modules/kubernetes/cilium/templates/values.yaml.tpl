aksbyocni:
  # -- Enable AKS BYOCNI integration.
  # Note that this is incompatible with AKS clusters not created in BYOCNI mode:
  # use Azure integration (`azure.enabled`) instead.
  enabled: true

hubble:
  # -- Enable Hubble (true by default).
  enabled: true

  relay:
    # -- Enable Hubble Relay (requires hubble.enabled=true)
    enabled: true
  ui:
    # -- Whether to enable the Hubble UI.
    enabled: true