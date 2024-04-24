#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Reference for network offset
"$SCRIPT_DIR"/test-eddsa.sh netload dalek

for DEPTH in 2; do
    for BATCH_SIZE in {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}; do
        "$SCRIPT_DIR"/test-dsig-wots.sh netload haraka $BATCH_SIZE $DEPTH
    done

    # for BATCH_SIZE in {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}; do
    #     "$SCRIPT_DIR"/test-cpu-tput.sh netload $BATCH_SIZE $DEPTH
    # done
done
