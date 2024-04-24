#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

BATCH_SIZE=7
for HASH in {haraka,sha256}; do
    for DEPTH in {1,2,3,4}; do
        "$SCRIPT_DIR"/test-dsig-wots.sh base32 $HASH $BATCH_SIZE $DEPTH -r 128
        # "$SCRIPT_DIR"/test-dsig-wots.sh prefetch32 $HASH $BATCH_SIZE $DEPTH -r 128 -c
    done
done