.ONESHELL:
SHELL := /bin/bash

all: fmt lint docs tfsec validate

.SILENT:
fmt:
	for d in modules/*; do
		for dd in $$d/*; do
			echo fmt: $$dd
			terraform fmt $$dd
		done
	done


.SILENT:
lint:
	for d in modules/*; do
		for dd in $$d/*; do
			echo lint: $$dd
			tflint -c $$d/.tflint.hcl $$dd
		done
	done

.SILENT:
docs:
	for d in modules/*; do
		for dd in $$d/*; do
			echo docs: $$dd
			terraform-docs markdown $$dd > $$dd/README.md
		done
	done

.SILENT:
tfsec:
	tfsec .

.SILENT:
validate:
	set -e
	CURRENT_DIR=$$PWD
	TF_MODULES=$$(find modules -maxdepth 2 -mindepth 2 -type d | sed "s|^modules/|validation/|g")
	for d in $$TF_MODULES; do
		cd $$CURRENT_DIR/$$d
		echo terraform-validate: $$d
		terraform init 1>/dev/null
		terraform validate
	done

.SILENT:
vscode-tf:
	CURRENT_DIR=$$PWD
	for d in modules/*; do
		for dd in $$d/*; do
			cd $$CURRENT_DIR/$$dd
			rm -rf .terraform
			terraform init
		done
	done
	cd $$CURRENT_DIR
	TF_MODULES=$$(find modules -depth 2 -type d)
	jq --arg arr "$${TF_MODULES}" '.["terraform-ls.rootModules"] = ($$arr | split("\n"))' .vscode/settings.json > .vscode/settings.json_new
	mv .vscode/settings.json_new .vscode/settings.json
