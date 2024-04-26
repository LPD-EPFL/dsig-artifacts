#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

NAME=$1
SCHEME=$2
INGRESS=$3
INGRESS_DELTA=$4
ARGS="${@:5}"

PARAM="--scheme $SCHEME"
EXEC="dsig-tput-wots-haraka-7-2"

for retry in $(seq 1 15); do
    if [ $retry -gt 1 ]; then
        echo "Retrying..."
    fi
    "${SCRIPT_DIR}"/setup-all-tmux.sh

    "${SCRIPT_DIR}"/remote-memc.sh machine1

    "${SCRIPT_DIR}"/remote-invoker.sh machine1 $NAME proc1 $EXEC $PARAM -l 1 -i $INGRESS -d $INGRESS_DELTA $ARGS
    "${SCRIPT_DIR}"/remote-invoker.sh machine2 $NAME proc2 $EXEC $PARAM -l 2 -i $INGRESS -d $INGRESS_DELTA $ARGS

    "${SCRIPT_DIR}"/wait-till-completion.sh machine1 proc1 60 || continue
done

"${SCRIPT_DIR}"/kill-all-tmux.sh
