#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

SUFFIX=$1
HASH=$2
BATCH_SIZE=$3
DEPTH=$4
ARGS="${@:5}"

PARAM="--scheme dsig"
EXEC="~/dsig/bin/dsig-ping-wots-$HASH-$BATCH_SIZE-$DEPTH"
# Name of the tmux AND output files
NAME="dsig-ping-wots-$HASH-b$BATCH_SIZE-d$DEPTH-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker.sh machine1 $NAME-1 $EXEC $PARAM -l 1 $ARGS
"$SCRIPT_DIR"/remote-invoker.sh machine2 $NAME-2 $EXEC $PARAM -l 2 $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
