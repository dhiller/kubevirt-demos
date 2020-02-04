#!/bin/bash

( which asciinema ) > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "asciinema is not installed!"
    exit 1
fi

( which figlet ) > /dev/null 2>&1
[ $? -eq 0 ] && figlet_available=1 || figlet_available=0

set -euo pipefail

if [ "$#" -gt 0 ]; then
    x="$1"
    start_at=$((x-1))
else
    start_at=0
fi

cat <<EOF
Following keyboard shortcuts are available:

Space   - toggle pause,
.       - step through a recording a frame at a time (when paused),
Ctrl+C  - exit.

to stop the demo, keep hitting ctrl+c....

EOF
sleep 3

must_stop=""

function stop_it {
    echo "stopping..." 
    must_stop="yes"
}

trap stop_it SIGINT SIGTERM

while true; do
    clear
    for demo_file in $(ls *-ascii.cast); do
        if [ "$start_at" -gt 0 ]; then
            start_at=$(($start_at-1))
            continue
        fi
        demo_name=$(echo $demo_file | sed -E 's/[0-9]+-kv-(.*)-ascii.cast/\1/')
        if [ $figlet_available -ne 0 ]; then
            width=$(tput cols)
            figlet -w "$width" "$demo_name"
            echo
        else
            echo "Next demo: $demo_name..."
            echo
        fi
        sleep 1
        asciinema play -i 1 -s 1.5 "$demo_file"
        [ -z "$must_stop" ] || exit 0
    done
done
