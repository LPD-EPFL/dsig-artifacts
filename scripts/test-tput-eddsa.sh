#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

SUFFIX=$1
SCHEME=$2
INGRESS=$3
INGRESS_DELTA=$4
ARGS="${@:5}"

PARAM="--scheme $SCHEME"
EXEC="$DSIG_DEPLOYMENT/bin/dsig-tput-wots-haraka-7-2"
# Name of the tmux AND output files
NAME="dsig-tput-$SCHEME-$INGRESS-$INGRESS_DELTA-$SUFFIX"

"$SCRIPT_DIR"/setup-all-tmux.sh

"$SCRIPT_DIR"/remote-memc.sh machine1

"$SCRIPT_DIR"/remote-invoker.sh machine1 $NAME-1 $EXEC $PARAM -l 1 -i $INGRESS -d $INGRESS_DELTA $ARGS
"$SCRIPT_DIR"/remote-invoker.sh machine2 $NAME-2 $EXEC $PARAM -l 2 -i $INGRESS -d $INGRESS_DELTA $ARGS

"$SCRIPT_DIR"/wait-till-completion.sh machine1 $NAME-1

"$SCRIPT_DIR"/kill-all-tmux.sh
