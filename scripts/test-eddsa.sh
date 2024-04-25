#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
SCHEME=$2
ARGS="${@:3}"

PARAM="--scheme $SCHEME"
EXEC="dsig-ping-wots-haraka-7-2"

"${SCRIPT_DIR}"/setup-all-tmux.sh

"${SCRIPT_DIR}"/remote-memc.sh machine1

"${SCRIPT_DIR}"/remote-invoker.sh machine1 $NAME proc1 $EXEC $PARAM -l 1 $ARGS
"${SCRIPT_DIR}"/remote-invoker.sh machine2 $NAME proc2 $EXEC $PARAM -l 2 $ARGS

"${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1

"${SCRIPT_DIR}"/kill-all-tmux.sh
