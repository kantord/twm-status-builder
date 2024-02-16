#!/usr/bin/env bash

cache_id=$(echo "laptop_battery_$(( $(date +%s) / 30 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi


upower -d | jc --upower | jq  '.[] | select (.detail.type == "battery") | .detail.percentage' | sed 's/\.0\?//' | sort -u | sed 's/$/%/' | sed 's/^/💻 /' > $cache_file

cat $cache_file
