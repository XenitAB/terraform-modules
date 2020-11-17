.ONESHELL:
SHELL := /bin/bash

all: fmt lint docs

.SILENT:
fmt:
	for d in modules/*; do
		for dd in $$d/*; do
			echo $$dd
			terraform fmt $$dd
		done
	done


.SILENT:
lint:
	for d in modules/*; do
		for dd in $$d/*; do
			echo $$dd
			tflint -c $$d/.tflint.hcl $$dd
		done
	done

.SILENT:
docs:
	for d in modules/*; do
		for dd in $$d/*; do
			echo $$dd
			terraform-docs markdown $$dd > $$dd/README.md
		done
	done