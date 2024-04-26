#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

FOLDER_NAME=$1
WIN_NAME=$2
BINARY=$3
TOML=$4
MAIN_THD=$5
BG_THD=$6
ARGS="${@:7}"

tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
    "source \"${SCRIPT_DIR}\"/config.sh; \
     mkdir -p \"${LOG_DIR}/${FOLDER_NAME}/\"; \
     export DSIG_CONFIG=\"$TOML_DIR/$TOML\"; \
     export DSIG_CORES=\"bg=$BG_THD\"; \
     stdbuf -o L -e L numactl -m 0 -N 0 -C $MAIN_THD \"${BIN_DIR}/$BINARY\" $ARGS 2>&1 | tee \"${LOG_DIR}/${FOLDER_NAME}/${WIN_NAME}.txt\"; \
     sleep 5"