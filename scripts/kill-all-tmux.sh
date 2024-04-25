#!/bin/bash

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

for i in $(seq 1 $MACHINE_COUNT); do
    MACHINE=$(machine2ssh machine$i)
    ssh -o LogLevel=QUIET -t $MACHINE \
        "tmux kill-session -t $TMUX_SESSION"
done
