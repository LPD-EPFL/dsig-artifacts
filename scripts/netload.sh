#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

ARGS="${@:1}"

tmux new-session -d -s $TMUX_SESSION &>/dev/null || true
tmux new-window -t $TMUX_SESSION -n "netload" "killall ib_write_bw; LD_PRELOAD=$SCRIPT_DIR/libreparent.so ib_write_bw $ARGS"
