#! /usr/bin/env bash

MODULES=$(dirname $0)/modules

active_modules=$(echo "$1" | tr ',' '\n')
cycled_modules=$(echo "$1" | tr -cd '>' | wc -c)
if [[ $cycled_modules -ne 0 ]]; then
	active_cycled_module=$(( $(date +%s) / 15 % $cycled_modules ))
fi

function execute_modules() {
	current_cycled_module=0
	for module_description in $active_modules
	do
		if [[ $module_description = \>* && "$active_cycled_module" -ne "$current_cycled_module" ]]; then
			current_cycled_module=$(($current_cycled_module+1))
			continue
		fi
		[[ $module_description = \>* ]] && current_cycled_module=$(($current_cycled_module+1))

		module_name=$(echo $module_description | sed 's/>//' | cut -f1 -d':')
		module_arg=$(echo $module_description | cut -f2 -d':')
		cat <($MODULES/$module_name.sh $module_arg)
	done
}

execute_modules | grep -v '^$' | head -n1
