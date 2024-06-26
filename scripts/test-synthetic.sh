#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

HASH=haraka
BATCH_SIZE=7
DEPTH=2

NAME=$1
SCHEME=$2
NB_CLIENTS=$3
PROC_TIME=$4
MSG_SIZE=$5
INGRESS=$6
INGRESS_DELTA=$7
ARGS="${@:8}"

PARAM="--scheme $SCHEME -c $NB_CLIENTS -P $PROC_TIME -s $MSG_SIZE -i $INGRESS -d $INGRESS_DELTA"
EXEC="dsig-synthetic-wots-$HASH-$BATCH_SIZE-$DEPTH"

for retry in $(seq 1 15); do
    if [ $retry -gt 1 ]; then
        echo "Retrying..."
    fi
    "${SCRIPT_DIR}"/setup-all-tmux.sh

    "${SCRIPT_DIR}"/remote-memc.sh machine1

    TOML="dsig-${NB_CLIENTS}s.toml"
    MAIN_THD=8
    BG_THD=10

    # "${SCRIPT_DIR}"/remote-netload.sh machine1

    "${SCRIPT_DIR}"/remote-invoker-scalability.sh machine1 $NAME proc1 $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l 1 $ARGS
    for i in $(seq 2 3 $(($NB_CLIENTS + 1))); do
        "${SCRIPT_DIR}"/remote-invoker-scalability.sh machine2 $NAME proc$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i $ARGS
        MAIN_THD=$(($MAIN_THD + 4))
        BG_THD=$(($BG_THD + 4))
    done

    # "${SCRIPT_DIR}"/remote-netload.sh machine2 $machine1 -b --rate_limit=80 -D 60

    MAIN_THD=8
    BG_THD=10
    for i in $(seq 3 3 $(($NB_CLIENTS + 1))); do
        "${SCRIPT_DIR}"/remote-invoker-scalability.sh machine3 $NAME proc$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i $ARGS
        MAIN_THD=$(($MAIN_THD + 4))
        BG_THD=$(($BG_THD + 4))
    done

    MAIN_THD=8
    BG_THD=10
    for i in $(seq 4 3 $(($NB_CLIENTS + 1))); do
        "${SCRIPT_DIR}"/remote-invoker-scalability.sh machine4 $NAME proc$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i $ARGS
        MAIN_THD=$(($MAIN_THD + 4))
        BG_THD=$(($BG_THD + 4))
    done

    "${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1 60 || continue
    break
done

"${SCRIPT_DIR}"/kill-all-tmux.sh
