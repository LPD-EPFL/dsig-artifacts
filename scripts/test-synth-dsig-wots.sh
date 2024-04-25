#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
HASH=$2
BATCH_SIZE=$3
DEPTH=$4
PROC_TIME=$5
INGRESS=$6
INGRESS_DELTA=$7
ARGS="${@:8}"

PARAM="--scheme dsig"
EXEC="dsig-synthetic-wots-$HASH-$BATCH_SIZE-$DEPTH"

"${SCRIPT_DIR}"/setup-all-tmux.sh

"${SCRIPT_DIR}"/remote-memc.sh machine1

# "${SCRIPT_DIR}"/remote-netload.sh machine1
"${SCRIPT_DIR}"/remote-invoker.sh machine1 $NAME proc1 $EXEC $PARAM -l 1 -P $PROC_TIME -i $INGRESS -d $INGRESS_DELTA $ARGS
# "${SCRIPT_DIR}"/remote-netload.sh machine2 $machine1 -b --rate_limit=80 -D 60
sleep 1
"${SCRIPT_DIR}"/remote-invoker.sh machine2 $NAME proc2 $EXEC $PARAM -l 2 -P $PROC_TIME -i $INGRESS -d $INGRESS_DELTA $ARGS

"${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1

"${SCRIPT_DIR}"/kill-all-tmux.sh
