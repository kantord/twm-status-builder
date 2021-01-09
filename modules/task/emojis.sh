#!/usr/bin/env bash

cache_id=$(echo "taskwarrior_emojis_$(( $(date +%s) / 3 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi

task overdue 2> /dev/null | sed 1,3d | head -n -1 | grep -v "^$" | grep -v "^     " | sed 's/^ *[0-9]\+ [0-9]\+[a-z] \? \? \? \?//' | cut -c-6 | sed 's/ */ /' | sed 's/^ *//' | sed 's/ *$//' | sed 's/^$/🍓/' | tr -d '\n\r' | sed 's/$/\n/' > $cache_file

echo "" >> $cache_file
echo "🥔" >> $cache_file

cat $cache_file

