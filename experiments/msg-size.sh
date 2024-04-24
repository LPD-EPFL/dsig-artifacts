#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

BATCH_SIZE=7
DEPTH=2
for MSG_SIZE in {8,16,32,64,128,256,512,1024,2048,4096,8192,16384}; do
    SUFFIX="msg$MSG_SIZE"
    "$SCRIPT_DIR"/test-pony-wots.sh $SUFFIX haraka $BATCH_SIZE $DEPTH -s $MSG_SIZE
    "$SCRIPT_DIR"/test-eddsa.sh $SUFFIX dalek -s $MSG_SIZE
    "$SCRIPT_DIR"/test-eddsa.sh $SUFFIX sodium -s $MSG_SIZE
done