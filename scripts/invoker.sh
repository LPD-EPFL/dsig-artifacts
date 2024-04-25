#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

FOLDER_NAME=$1
WIN_NAME=$2
BINARY=$3
ARGS="${@:4}"

tmux new-window -t $TMUX_SESSION -n "$WIN_NAME" \
    "source \"${SCRIPT_DIR}\"/config.sh; \
     mkdir -p \"${LOG_DIR}/${FOLDER_NAME}/\"; \
     stdbuf -o L -e L numactl -m 0 -N 0 -C 8 \"${BIN_DIR}/$BINARY\" $ARGS 2>&1 | tee \"${LOG_DIR}/${FOLDER_NAME}/${WIN_NAME}.txt\"; \
     sleep 5"