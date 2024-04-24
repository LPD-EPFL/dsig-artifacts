#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

SUFFIX=$1
SCHEME=$2
# NBCLIENTS=$3
ARGS="${@:3}"

EXEC="~/dsig/bin/ubft-$SCHEME"
# Name of the tmux AND output files
NAME="ubft-$SCHEME-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker-ubft.sh machine1 $NAME-1 $EXEC -l 1 $ARGS
"$SCRIPT_DIR"/remote-invoker-ubft.sh machine2 $NAME-2 $EXEC -l 2 $ARGS
"$SCRIPT_DIR"/remote-invoker-ubft.sh machine3 $NAME-3 $EXEC -l 3 $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
