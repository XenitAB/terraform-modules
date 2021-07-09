MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
/etc/eks/bootstrap.sh --b64-cluster-ca ${b64_cluster_ca} --apiserver-endpoint ${api_server_url} --use-max-pods false ${cluster_name}

--==MYBOUNDARY==--
