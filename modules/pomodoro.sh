#!/usr/bin/env bash

DEFAULT_I3_GNOME_POMODORO_PATH="i3-gnome-pomodoro"
I3_GNOME_POMODORO_PATH="${I3_GNOME_POMODORO_ENV_PATH:-$DEFAULT_I3_GNOME_POMODORO_PATH}"
"$I3_GNOME_POMODORO_PATH" status | sed 's/^/🍅 /' | grep -v "^🍅 $"
