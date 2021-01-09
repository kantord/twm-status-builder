#!/usr/bin/env bash

cache_id=$(echo "taskwarrior_$(( $(date +%s) / 3 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi

task overdue | tail -n1 | sed 's/^/陼 /' | sed 's/ tasks//' > $cache_file
cat $cache_file

