.ONESHELL:
SHELL := /bin/bash

all: fmt lint docs tfsec validate

.SILENT:
fmt:
	set -e

	tf_fmt () {
		set -e
		echo fmt: $${1}
		terraform fmt -recursive $${1}
		terraform fmt -recursive $${1/modules/validation}
	}

	export -f tf_fmt

	TF_MODULES=$$(find modules -maxdepth 2 -mindepth 2 -type d)

	PARALLEL_JOBS=10
	printf '%s\n' $${TF_MODULES[@]} | parallel --halt now,fail=1 -j$${PARALLEL_JOBS} "tf_fmt {}"

.SILENT:
lint:
	set -e
	echo lint: Start
	MODULE_GROUPS=$$(find modules -mindepth 1 -maxdepth 1 -type d)
	for MODULE_GROUP in $${MODULE_GROUPS}; do
		tflint --init -c .tflint.hcl --chdir $${MODULE_GROUP}
		MODULES=$$(find $${MODULE_GROUP} -mindepth 1 -maxdepth 1 -type d)
		for MODULE in $$MODULES; do
			echo lint: $${MODULE}
			tflint -c ../.tflint.hcl --chdir $${MODULE}
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
		rm -f $$1/.terraform.lock.hcl
		terraform -chdir=$$1 init 1>/dev/null 2>&1
		TEMP_FILE=$$(mktemp)
		
		set -e
		if ! terraform -chdir=$$1 validate 1>$${TEMP_FILE} 2>&1; then
			echo terraform-validate: $$1 failed 1>&2
			cat $${TEMP_FILE} 1>&2
			rm $${TEMP_FILE}
			return 1
		fi

		rm $${TEMP_FILE}
		echo terraform-validate: $$1 succeeded
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
