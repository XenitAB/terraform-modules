#!/bin/bash

echo "hello world"
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install jq apt-transport-https ca-certificates curl zsh -y

snap install go --classic
snap install kubectl --classic
sudo snap install helm --classic
sudo snap install aws-cli --classic
sudo snap install kustomize

# Install az
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Config bashrc
mkdir ~/.kube/
kubectl completion bash > ~/.kube/completion.bash.inc
helm completion bash > ~/.kube/helm-completion.bash.inc

cat <<EOF >> ~/.bashrc

alias k=kubectl
export TERM=vt100
source ~/.kube/completion.bash.inc
source ~/.kube/helm-completion.bash.inc
EOF
