#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

SUFFIX=$1
SCHEME=$2
# NBCLIENTS=$3
ARGS="${@:3}"

EXEC="$DSIG_DEPLOYMENT/bin/ubft-tcb-$SCHEME"
# Name of the tmux AND output files
NAME="ubft-tcb-$SCHEME-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker-ubft.sh machine1 $NAME-1 $EXEC -l 1 $ARGS
"$SCRIPT_DIR"/remote-invoker-ubft.sh machine2 $NAME-2 $EXEC -l 2 $ARGS
"$SCRIPT_DIR"/remote-invoker-ubft.sh machine3 $NAME-3 $EXEC -l 3 $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
