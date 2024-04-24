#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

SUFFIX=$1
HASH=haraka
BATCH_SIZE=$2
DEPTH=$3
ARGS="${@:4}"

# PARAM="--scheme dsig"
EXEC="~/dsig/bin/dsig-cpu-tput-wots-$HASH-$BATCH_SIZE-$DEPTH"
# Name of the tmux AND output files
NAME="dsig-cpu-tput-wots-$HASH-b$BATCH_SIZE-d$DEPTH-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker.sh machine1 $NAME-1 $EXEC $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
