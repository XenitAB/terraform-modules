#!/bin/bash

sudo yum update -y
sudo yum install jq curl zsh python3-pip -y
EC2HOME="/home/ec2-user"

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# helm
export PATH=$PATH:/usr/local/bin
curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 |bash

# Kustomize
cd /usr/local/bin
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
cd -

# Install az ec2-user, didn't get it to work for root in a good way.
#su ec2-user -c 'pip3 install az --user'
# Autocomplete ec2-user
mkdir $EC2HOME/.kube/
kubectl completion bash > $EC2HOME/.kube/completion.bash.inc
helm completion bash > $EC2HOME/.kube/helm-completion.bash.inc
kustomize completion bash > $EC2HOME/.kube/kustomize-completion.bash.inc
chown -R ec2-user:ec2-user $EC2HOME/.kube

# Config bashrc ec2-user
cat <<EOF >> $EC2HOME/.bashrc

alias k=kubectl
export TERM=vt100
source ~/.kube/completion.bash.inc
source ~/.kube/helm-completion.bash.inc
source ~/.kube/kustomize-completion.bash.inc
export AWS_PROFILE=xkf

EOF

# aws config
mkdir $EC2HOME/.aws

cat <<EOF >> $EC2HOME/.aws/config
[profile xkf]
role_arn = arn:aws:iam::${account}:role/eks-admin-ec2
credential_source = Ec2InstanceMetadata
region = ${region}
EOF

chown -R ec2-user:ec2-user $EC2HOME/.aws
