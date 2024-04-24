#!/bin/bash

# Valid values for PLATFORM_ARCHITECTURE are:
#   'darwin_amd64', 'darwin_arm64', 'linux_386', 'linux_amd64', 'linux_arm', 'linux_arm64', 'windows_386', 'windows_amd64'
PLATFORM_ARCHITECTURE="linux_amd64"
PLUGINS=("azurerm|0.26.0")

setup_local_tflint_plugin() {
    for PLUGIN in ${PLUGINS[@]}; do
        TFLINT_PLUGIN_NAME=${PLUGIN%|*}
        TFLINT_PLUGIN_VERSION=${PLUGIN#*|}
        TFLINT_PLUGIN_DIR=~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-${TFLINT_PLUGIN_NAME}/${TFLINT_PLUGIN_VERSION}
        
        mkdir -p $TFLINT_PLUGIN_DIR
        FILE=$TFLINT_PLUGIN_DIR/tflint-ruleset-${TFLINT_PLUGIN_NAME}
        if [ ! -f "$FILE" ]; then
            echo "Downloading version ${TFLINT_PLUGIN_VERSION} of the ${TFLINT_PLUGIN_NAME} plugin."
            (cd ${TFLINT_PLUGIN_DIR} && curl -L "https://github.com/terraform-linters/tflint-ruleset-${TFLINT_PLUGIN_NAME}/releases/download/v${TFLINT_PLUGIN_VERSION}/tflint-ruleset-${TFLINT_PLUGIN_NAME}_${PLATFORM_ARCHITECTURE}.zip" -o provider.zip && unzip provider.zip && rm provider.zip)
            chmod -R +x ~/.tflint.d/plugins
        fi
    done
}

setup_local_tflint_plugin
