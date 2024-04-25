#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
APP=$2
CONFIG=$3
SCHEME=$4
ARGS="${@:5}"

ARGS=" --dev mlx5_1 --client-id 2 --application $APP -c $CONFIG --scheme $SCHEME $ARGS"

"${SCRIPT_DIR}"/setup-all-tmux.sh

"${SCRIPT_DIR}"/remote-memc.sh machine1

"${SCRIPT_DIR}"/remote-invoker.sh machine1 $NAME server audit-server --local-id 1 $ARGS
"${SCRIPT_DIR}"/remote-invoker.sh machine2 $NAME client audit-client --local-id 2 --server-id 1 $ARGS

"${SCRIPT_DIR}"/wait-till-completion.sh machine2 client

"${SCRIPT_DIR}"/kill-all-tmux.sh
