loki: 
  rbac:
    pspEnabled: false
  config:
    schema_config:
      configs:
        - from: 2020-07-01
          store: boltdb-shipper
          object_store: aws
          schema: v11
          index:
            prefix: index_
            period: 24h
    storage_config:
      aws:
        s3forcepathstyle: true
