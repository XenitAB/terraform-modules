# Local dns

How to configure localdns.yaml

```shell
export kubedns=$(kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP})
export domain=cluster.local
export localdns=169.254.20.10
sed -i "s/__PILLAR__LOCAL__DNS__/$localdns/g; s/__PILLAR__DNS__DOMAIN__/$domain/g; s/__PILLAR__DNS__SERVER__/$kubedns/g" nodelocaldns.yaml
```

## links

[official docs](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/)
