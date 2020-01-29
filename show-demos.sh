#!/bin/bash

( which asciinema ) > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "asciinema is not installed!"
    exit 1
fi

set -euo pipefail

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
    for demo_file in $(ls *-ascii.cast); do
        echo "Next demo: $demo_file..."
        echo
        sleep 1
        asciinema play -i 1 -s 1.5 "$demo_file"
        [ -z "$must_stop" ] || exit 0
    done
done
