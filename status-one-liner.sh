#! /usr/bin/env bash

MODULES=$(dirname $0)/modules

show_index=1

cat <(cat <($MODULES/calendar_summary.sh) <($MODULES/calendar_upcoming.sh) <($MODULES/notification.sh) <($MODULES/pomodoro.sh) | grep -v '^$' | tail -n $show_index) <(echo "") | head -n1
