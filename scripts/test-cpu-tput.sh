#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
HASH=haraka
BATCH_SIZE=$2
DEPTH=$3
ARGS="${@:4}"

# PARAM="--scheme dsig"
EXEC="dsig-cpu-tput-wots-$HASH-$BATCH_SIZE-$DEPTH"

"${SCRIPT_DIR}"/setup-all-tmux.sh

"${SCRIPT_DIR}"/remote-memc.sh machine1

"${SCRIPT_DIR}"/remote-invoker.sh machine1 $NAME proc1 $EXEC $ARGS

"${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1

"${SCRIPT_DIR}"/kill-all-tmux.sh
