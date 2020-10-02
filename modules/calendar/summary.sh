#!/usr/bin/env bash

cache_id=$(echo "sol_calendar_summary_$(( $(date +%s) / 180 ))" | md5sum | head -n1 | cut -f1 -d' ')
cache_file="/tmp/$cache_id"

if test -f "$cache_file"; then
	cat $cache_file
	exit 0
fi


let FIRST_HOUR=7
let LAST_HOUR=23
let START="2*FIRST_HOUR"
let END="2*LAST_HOUR"
let WORK_START="2*10"
let WORK_END="2*18"
let LUNCH_BREAK_START="2*13"
let LUNCH_BREAK_END="LUNCH_BREAK_START + 2"

source ~/.status-one-liner-rc

day_summary=""
EVENTS_TODAY=`khal list today -f "{start-date};={start-time};{end-time};{title}" | sed '/Tomorrow/q' | grep "=" | cut -f2 -d"=" | grep -v "No meetings day /blocker/" | grep -v "^;"`

HOUR=`date +"%H" | sed 's/^0//'`
MINUTE=`date +"%M" |sed  's/^0//'`
let CURRENT_TIME="2*HOUR+1"
if [ "$MINUTE" -gt "30" ]; then
	let CURRENT_TIME="1+CURRENT_TIME"
fi

for i in $(eval echo "{$START..$END}")
do
	time_symbol="🟩"
	if [ "$i" -eq "$START" ]; then
		time_symbol="⏰"
	fi
	if [ "$i" -gt "$WORK_START" ]; then
		time_symbol="🟦"
	fi
	if [ "$i" -ge "$LUNCH_BREAK_START" ]; then
		if [ "$i" -lt "$LUNCH_BREAK_END" ]; then
			time_symbol="🍴"
		fi
	fi
	if [ "$i" -gt "$WORK_END" ]; then
		time_symbol="🟩"
	fi
	if [[ $(date +%u) -gt 5 ]]; then
		time_symbol="🟩"
	fi
	if [ "$i" -eq "$END" ]; then
		time_symbol="💤"
	fi
	while IFS= read -r meeting; do
		if test -z "$meeting" 
		then
		      continue
		fi
		meeting_start=`echo $meeting | cut -f1 -d';'`
		meeting_end=`echo $meeting | cut -f2 -d';'`
		SEC1=`date +%s -d ${meeting_start}`
		SEC2=`date +%s -d ${meeting_end}`
		DIFFSEC=`expr ${SEC2} - ${SEC1}`
		if test -z "$DIFFSEC" 
		then
		      continue
		fi
		let TOTAL_BLOCKS="$DIFFSEC / 1800"
		if [ "$TOTAL_BLOCKS" -eq "0" ]; then
			TOTAL_BLOCKS=1
		fi
		let EXTRA_BLOCKS="$TOTAL_BLOCKS - 1"
		HOUR=`echo $meeting_start | cut -f1 -d':' | sed 's/^0//'`
		MINUTE=`echo $meeting_start | cut -f1 -d':'`
		let MEETING_TIME="2*HOUR+1"
		let MEETING_END_TIME="MEETING_TIME+EXTRA_BLOCKS"
		if [ "$MINUTE" -gt "30" ]; then
			let MEETING_TIME="1+MEETING_TIME"
		fi

		if [ "$i" -ge "$MEETING_TIME" ]; then
			if [ "$i" -le "$MEETING_END_TIME" ]; then
				time_symbol="📅"
			fi
		fi

	done <<< "$EVENTS_TODAY"
	if [ "$i" -eq "$CURRENT_TIME" ]; then
		time_symbol="🚀"
	fi
	day_summary="$day_summary$time_symbol"
done

echo $day_summary > $cache_file
cat $cache_file
