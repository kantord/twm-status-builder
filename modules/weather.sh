#!/usr/bin/env bash

cities=$(echo $1 | tr '_' ' ')

curl -s "wttr.in/$cities?format=3"
