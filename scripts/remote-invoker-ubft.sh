#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"
source "$SCRIPT_DIR"/config.sh

M=$1
ARGS="${@:2}"

MACHINE=$(machine2ssh $M)

ssh -o LogLevel=QUIET -t $MACHINE "$DSIG_DEPLOYMENT/scripts/invoker-ubft.sh $ARGS"

echo "Launched on $MACHINE: $DSIG_DEPLOYMENT/scripts/invoker-ubft.sh -X 24 $ARGS"
