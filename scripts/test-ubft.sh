#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
SCHEME=$2
# NBCLIENTS=$3
ARGS="${@:3}"

EXEC="ubft-$SCHEME"

"${SCRIPT_DIR}"/setup-all-tmux.sh

"${SCRIPT_DIR}"/remote-memc.sh machine1

"${SCRIPT_DIR}"/remote-invoker-ubft.sh machine1 $NAME proc1 $EXEC -l 1 $ARGS
"${SCRIPT_DIR}"/remote-invoker-ubft.sh machine2 $NAME proc2 $EXEC -l 2 $ARGS
"${SCRIPT_DIR}"/remote-invoker-ubft.sh machine3 $NAME proc3 $EXEC -l 3 $ARGS

"${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1

"${SCRIPT_DIR}"/kill-all-tmux.sh
