#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

SUFFIX=$1

"$SCRIPT_DIR"/test-ubft-tcb.sh $SUFFIX dsig --core 26
"$SCRIPT_DIR"/test-ubft-tcb.sh $SUFFIX free
"$SCRIPT_DIR"/test-ubft-tcb.sh $SUFFIX large
"$SCRIPT_DIR"/test-ubft-tcb.sh $SUFFIX dalek
"$SCRIPT_DIR"/test-ubft-tcb.sh $SUFFIX sodium
