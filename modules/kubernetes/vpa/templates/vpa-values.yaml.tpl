priorityClassName: platform-medium

recommender:
  # recommender.enabled -- If true, the vpa recommender component will be installed.
  enabled: true
  # recommender.extraArgs -- A set of key-value flags to be passed to the recommender
  extraArgs:
    v: "4"
    pod-recommendation-min-cpu-millicores: 15
    pod-recommendation-min-memory-mb: 24
    prometheus-address: http://prometheus-operated.prometheus.svc.cluster.local:9090
    storage: prometheus
    # How much time back prometheus have to be queried to get historical metrics
    # history-length: 8
  image:
    # recommender.image.repository -- The location of the recommender image
    repository: k8s.gcr.io/autoscaling/vpa-recommender
    # recommender.image.pullPolicy -- The pull policy for the recommender image. Recommend not changing this
    pullPolicy: Always
    # recommender.image.tag -- Overrides the image tag whose default is the chart appVersion
    tag: ""
  resources:
    limits:
      cpu: 200m
      memory: 500Mi
    requests:
      cpu: 50m
      memory: 250Mi

updater:
  # updater.enabled -- If true, the updater component will be deployed
  enabled: false

admissionController:
  # admissionController.enabled -- If true, will install the admission-controller component of vpa
  enabled: false
