#!/usr/bin/env bash

cities=$(echo $1 | tr '_' ' ')
cache_id=$(echo "sol_weather_$cities$(( $(date +%s) / 180 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi

curl -s "wttr.in/$cities?format=3" -o "$cache_file" --max-time 0.25
cat $cache_file
