#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

SUFFIX=$1
APP=$2
CONFIG=$3
SCHEME=$4
ARGS="${@:5}"

# Name of the tmux AND output files
NAME="$APP-$SCHEME-$SUFFIX"
ARGS=" --dev mlx5_1 --client-id 2 --application $APP -c $CONFIG --scheme $SCHEME $ARGS"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker.sh machine1 $NAME-1 "audit-server" --local-id 1 $ARGS
"$SCRIPT_DIR"/remote-invoker.sh machine2 $NAME-2 "audit-client" --local-id 2 --server-id 1 $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine2 $NAME-2

"$SCRIPT_DIR"/kill-all-tmux.sh
