# Contributing



## Setup
Install latest make version on macOS
```
brew install make
```

Install tflint azure plugin
```
ARCH="linux" # or darwin if macOS
cd $HOME/.tflint.d/plugins
wget https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v0.6.0/tflint-ruleset-azurerm_${ARCH}_amd64.zip
unzip tflint-ruleset-azurerm_${ARCH}_amd64.zip
rm tflint-ruleset-azurerm_${ARCH}_amd64.zip
```
