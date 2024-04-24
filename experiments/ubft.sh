#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

SUFFIX=$1

"$SCRIPT_DIR"/test-ubft.sh $SUFFIX pony --core 26
"$SCRIPT_DIR"/test-ubft.sh $SUFFIX free
"$SCRIPT_DIR"/test-ubft.sh $SUFFIX large
"$SCRIPT_DIR"/test-ubft.sh $SUFFIX dalek
"$SCRIPT_DIR"/test-ubft.sh $SUFFIX sodium
