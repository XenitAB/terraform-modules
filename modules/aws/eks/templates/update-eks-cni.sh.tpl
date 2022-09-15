TMPDIR=$(mktemp -d) && \
export KUBECONFIG="$TMPDIR/config" && \
kubectl config set clusters.cluster-admin.server ${api_server_url} && \
kubectl config set clusters.cluster-admin.certificate-authority-data ${b64_cluster_ca} && \
kubectl config set users.cluster-admin.token ${token} && \
kubectl config set contexts.cluster-admin.cluster cluster-admin && \
kubectl config set contexts.cluster-admin.user cluster-admin && \
kubectl config set contexts.cluster-admin.namespace kube-system && \
kubectl --context=cluster-admin delete ds aws-node -n kube-system --ignore-not-found=true
