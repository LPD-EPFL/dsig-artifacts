#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

SUFFIX=$1
MODE=$2
HASH=$3
BATCH_SIZE=$4
SECRETS=$5
ARGS="${@:6}"

PARAM="--scheme dsig"
EXEC="dsig-ping-hors-$MODE-$HASH-$BATCH_SIZE-$SECRETS"
# Name of the tmux AND output files
NAME="dsig-ping-hors-$MODE-$HASH-b$BATCH_SIZE-k$SECRETS-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker.sh machine1 $NAME-1 $EXEC $PARAM -l 1 $ARGS
"$SCRIPT_DIR"/remote-invoker.sh machine2 $NAME-2 $EXEC $PARAM -l 2 $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
