#! /usr/bin/env bash

MODULES=$(dirname $0)/modules

active_modules=$(echo "$1" | tr ',' '\n')

function execute_modules() {
	for module_description in $active_modules
	do
		module_name=$(echo $module_description | cut -f1 -d':')
		module_arg=$(echo $module_description | cut -f2 -d':')
		cat <($MODULES/$module_name.sh $module_arg)
	done
}

execute_modules | grep -v '^$' | head -n1
