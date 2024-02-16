#!/usr/bin/env bash

cache_id=$(echo "bluetoot_headphones_battery_$(( $(date +%s) / 30 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi


upower -d | jc --upower | jq -r '[.[] | select(.type == "Device" and .detail.type == "headphones" and (.detail.percentage | tostring | contains("should be ignored") | not)) | "\ud83c\udfa7 \(.detail.percentage)%"] | join(" | ")' | sed 's/\.0\?//' > $cache_file

cat $cache_file
