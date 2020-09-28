#!/usr/bin/env bash

cache_id=$(echo "taskwarrior_$(( $(date +%s) / 3 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
fi

task overdue | tail -n1 | sed 's/$/ due/' > $cache_file
cat $cache_file

