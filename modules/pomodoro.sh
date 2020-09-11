#!/usr/bin/env bash

i3-gnome-pomodoro status | sed 's/^/🍅 /' | grep -v "^🍅 $"
