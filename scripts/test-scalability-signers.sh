#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

HASH=haraka
BATCH_SIZE=7
DEPTH=2

SUFFIX=$1
SCHEME=$2
NB_CLIENTS=$3
INGRESS=$4
INGRESS_DELTA=$5
ARGS="${@:6}"

CLIENTS=$(echo $(seq 2 1 $(($NB_CLIENTS + 1))) | sed 's/ / -s /g');

PARAM="-v 1 -s $CLIENTS" # String of the form "-v 1 -s 2 -s 3 -s 4 ..."
EXEC="dsig-scalability-wots-$HASH-$BATCH_SIZE-$DEPTH"
# Name of the tmux AND output files
[[ $SCHEME = "dsig" ]] && SCHEME_NAME="wots-$HASH-b$BATCH_SIZE-d$DEPTH" || SCHEME_NAME="$SCHEME"
NAME="dsig-scalability-signers-$SCHEME_NAME-$NB_CLIENTS-$INGRESS-$INGRESS_DELTA-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

TOML="dsig-${NB_CLIENTS}s.toml"
MAIN_THD=8
BG_THD=10

"$SCRIPT_DIR"/remote-invoker-scalability.sh machine1 $NAME-1 $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l 1 -i $INGRESS -d $INGRESS_DELTA --scheme $SCHEME $ARGS
for i in $(seq 2 3 $(($NB_CLIENTS + 1))); do
    "$SCRIPT_DIR"/remote-invoker-scalability.sh machine2 $NAME-$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i -i $INGRESS -d $INGRESS_DELTA --scheme $SCHEME $ARGS
    MAIN_THD=$(($MAIN_THD + 4))
    BG_THD=$(($BG_THD + 4))
done

MAIN_THD=8
BG_THD=10
for i in $(seq 3 3 $(($NB_CLIENTS + 1))); do
    "$SCRIPT_DIR"/remote-invoker-scalability.sh machine3 $NAME-$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i -i $INGRESS -d $INGRESS_DELTA --scheme $SCHEME $ARGS
    MAIN_THD=$(($MAIN_THD + 4))
    BG_THD=$(($BG_THD + 4))
done

MAIN_THD=8
BG_THD=10
for i in $(seq 4 3 $(($NB_CLIENTS + 1))); do
    "$SCRIPT_DIR"/remote-invoker-scalability.sh machine4 $NAME-$i $EXEC $TOML $MAIN_THD $BG_THD $PARAM -l $i -i $INGRESS -d $INGRESS_DELTA --scheme $SCHEME $ARGS
    MAIN_THD=$(($MAIN_THD + 4))
    BG_THD=$(($BG_THD + 4))
done

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
