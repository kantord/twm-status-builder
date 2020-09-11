#!/usr/bin/env bash

cat /tmp/last_notification.txt | sed 's/$/\n/' | sed 's/^/🔔 /' | grep -v '^🔔 $'
