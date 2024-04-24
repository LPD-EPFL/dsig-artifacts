#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"
source "$SCRIPT_DIR"/config.sh

WIN_NAME=$1
BIN_PATH=$2
ARGS="${@:3}"

tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
    "source \"$SCRIPT_DIR\"/config.sh; \
     stdbuf -o L -e L numactl -m 0 -N 0 -C 8 $DSIG_DEPLOYMENT/bin/$BIN_PATH $ARGS 2>&1 | tee ${DSIG_DEPLOYMENT}/logs/${WIN_NAME}.txt;"
# tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
#     "source \"$SCRIPT_DIR\"/config.sh; \
#      stdbuf -o L -e L numactl -m 0 -N 0 $BIN_PATH $ARGS 2>&1 | tee dsig/logs/${WIN_NAME}.txt;"
