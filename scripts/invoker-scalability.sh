#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"
TOML_DIR="$( realpath -sm  $SCRIPT_DIR/../toml/ )"
source "$SCRIPT_DIR"/config.sh

WIN_NAME=$1
BIN_PATH=$2
TOML=$3
MAIN_THD=$4
BG_THD=$5
ARGS="${@:6}"

tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
    "source \"$SCRIPT_DIR\"/config.sh; \
     export DSIG_CONFIG=\"$TOML_DIR/$TOML\"; \
     export DSIG_CORES=\"bg=$BG_THD\"; \
     stdbuf -o L -e L numactl -m 0 -N 0 -C $MAIN_THD $DSIG_DEPLOYMENT/bin/$BIN_PATH $ARGS 2>&1 | tee ${DSIG_DEPLOYMENT}/logs/${WIN_NAME}.txt;"
# tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
#     "source \"$SCRIPT_DIR\"/config.sh; \
#      stdbuf -o L -e L numactl -m 0 -N 0 $BIN_PATH $ARGS 2>&1 | tee dsig/logs/${WIN_NAME}.txt;"
