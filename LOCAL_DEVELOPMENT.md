# Local Development

Follow these instructions to install the tools you need.

## Installing tools

### Terraform

```shell
TFENV_VERSION=v3.0.0
git clone -b ${TFENV_VERSION} https://github.com/tfutils/tfenv.git /opt/tfenv
ln -s /opt/tfenv/bin/* /usr/local/bin
chown <user>:<group> /opt/tfenv
```

```shell
TF_VERSION=1.3.0
tfenv install ${TF_VERSION}
tfenv use ${TF_VERSION}
```

### tflint

```shell
TFLINT_VERSION=v0.42.1
cd /tmp
wget https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip
mv tflint /usr/bin/tflint
```

### tfsec

```shell
TFSEC_VERSION=v1.27.1
cd /tmp
wget https://github.com/tfsec/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64
chmod +x tfsec-linux-amd64
mv tfsec-linux-amd64 /usr/bin/tfsec
```

### terraform-docs

```shell
TERRAFORM_DOCS_VERSION=v0.16.0
cd /tmp
wget https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz
tar xzvf terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz terraform-docs
mv terraform-docs /usr/bin/terraform-docs
```

### paralell

Use package manager of choice for your distribution.

Arch:

```shell
sudo pacman -S parallel
```

Ubuntu:

```shell
sudo apt install parallel
````