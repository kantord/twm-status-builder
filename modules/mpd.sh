#!/usr/bin/env bash

# get the current song status
song_status=$(mpc current)

# check if a song is playing
if [ -n "$song_status" ]; then
    # if a song is playing, display the song with a music emoji
    echo "🎵 $song_status"
else
    # if no song is playing, display nothing
    echo ""
fi
