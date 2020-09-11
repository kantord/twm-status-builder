#! /usr/bin/env bash

MODULES=$(dirname $0)/modules

active_modules=$(echo "$1" | tr ',' '\n')

function execute_modules() {
	for module_name in $active_modules
	do
		cat <($MODULES/$module_name.sh)
	done
}

execute_modules | grep -v '^$' | head -n1
