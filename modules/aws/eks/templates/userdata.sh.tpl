MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -ex
B64_CLUSTER_CA=${b64_cluster_ca}
API_SERVER_URL=${api_server_url}
/etc/eks/bootstrap.sh ${cluster_name} --kubelet-extra-args '--node-labels=eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=${node_group}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --use-max-pods false

--==MYBOUNDARY==--
