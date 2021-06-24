.ONESHELL:
SHELL := /bin/bash

all: fmt lint docs tfsec validate

.SILENT:
fmt:
	set -e
	echo fmt: Start
	MODULE_GROUPS=$$(find modules -mindepth 1 -maxdepth 1 -type d)
	for MODULE_GROUP in $${MODULE_GROUPS}; do
		MODULES=$$(find $${MODULE_GROUP} -mindepth 1 -maxdepth 1 -type d)
		for MODULE in $$MODULES; do
			echo fmt: $${MODULE}
			terraform fmt $${MODULE}
		done
	done
	echo fmt: Success


.SILENT:
lint:
	set -e
	echo lint: Start
	MODULE_GROUPS=$$(find modules -mindepth 1 -maxdepth 1 -type d)
	for MODULE_GROUP in $${MODULE_GROUPS}; do
		MODULES=$$(find $${MODULE_GROUP} -mindepth 1 -maxdepth 1 -type d)
		for MODULE in $$MODULES; do
			echo lint: $${MODULE}
			tflint -c $${MODULE_GROUP}/.tflint.hcl $${MODULE}
		done
	done
	echo lint: Success

.SILENT:
docs:
	set -e
	echo docs: Start
	MODULE_GROUPS=$$(find modules -mindepth 1 -maxdepth 1 -type d)
	for MODULE_GROUP in $${MODULE_GROUPS}; do
		MODULE_GROUP_README_FILE="$${MODULE_GROUP}/README.md"
		if [[ ! $$(grep "$${MODULE_GROUP_README_FILE}" ./README.md) ]]; then
			echo docs: ERROR! Add reference for $${MODULE_GROUP_README_FILE} to ./README.md.
			exit 1
		fi
		MODULES=$$(find $${MODULE_GROUP} -mindepth 1 -maxdepth 1 -type d)
		for MODULE in $$MODULES; do
			README_FILE="$${MODULE}/README.md"
			echo docs: $${MODULE}
			terraform-docs markdown $${MODULE} > $${README_FILE}
			MODULE_README_FILE_SHORT=$$(echo $${MODULE}/README.md | sed "s|$${MODULE_GROUP}/||g")
			if [[ ! $$(grep "$${MODULE_README_FILE_SHORT}" $${MODULE_GROUP_README_FILE}) ]]; then
				echo docs: ERROR! Add reference for $${MODULE_README_FILE_SHORT} to $${MODULE_GROUP_README_FILE}.
				exit 1
			fi
		done
	done
	echo docs: Success

.SILENT:
tfsec:
	set -e
	echo tfsec: Start
	tfsec .
	echo tfsec: Success

.SILENT:
validate:
	set -e

	tf_validate () {
		cd $$1
		rm -f .terraform.lock.hcl
		terraform init 1>/dev/null
		set +e
		OUTPUT=$$(terraform validate 2>&1)
		EXIT_CODE=$$?
		set -e
		if [[ $$EXIT_CODE -ne 0 ]]; then
			echo terraform-validate: $$1 failed
			echo "$$OUTPUT"
			exit $$EXIT_CODE
		fi

		echo terraform-validate: $$1 succeeded
		exit $$EXIT_CODE
	}

	export -f tf_validate

	TF_MODULES=$$(find modules -maxdepth 2 -mindepth 2 -type d | sed "s|^modules/|validation/|g")

	PARALLEL_JOBS=10
	printf '%s\n' $${TF_MODULES[@]} | parallel --halt now,fail=1 -j$${PARALLEL_JOBS} "tf_validate {}"

.SILENT:
terraform-init:
	set -e
	CURRENT_DIR=$${PWD}
	MODULE_GROUPS=$$(find modules -mindepth 1 -maxdepth 1 -type d)
	for MODULE_GROUP in $${MODULE_GROUPS}; do
		MODULES=$$(find $${MODULE_GROUP} -mindepth 1 -maxdepth 1 -type d)
		for MODULE in $$MODULES; do
			cd $${CURRENT_DIR}/$${MODULE}
			echo terraform-init: $${CURRENT_DIR}/$${MODULE}
			terraform init 1>/dev/null
		done
	done
