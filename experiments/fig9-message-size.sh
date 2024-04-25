#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# Otherwise, run the following to unlimit bandwidth:
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig9-message-size"

LOG_BATCH_SIZE=7
LOG_DEPTH=2
for MSG_SIZE in {8,16,32,64,128,256,512,1024,2048,4096,8192}; do
    "${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/msgs-of-${MSG_SIZE}B/dsig haraka $LOG_BATCH_SIZE $LOG_DEPTH -s $MSG_SIZE
    "${SCRIPT_DIR}"/test-eddsa.sh $FIGURE_NAME/msgs-of-${MSG_SIZE}B/eddsa-dalek dalek -s $MSG_SIZE
    "${SCRIPT_DIR}"/test-eddsa.sh $FIGURE_NAME/msgs-of-${MSG_SIZE}B/eddsa-sodium sodium -s $MSG_SIZE
done