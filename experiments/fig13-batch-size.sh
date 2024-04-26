#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Warning: This will reduce the bandwitdth of the network card to 10Gbps and can impact other experiments.
# It is thus important to remove the limit afterward if the script is interrupted.
"${SCRIPT_DIR}"/limit-bandwidth.sh

FIGURE_NAME="fig13-batch-size"

# Reference for network offset
"${SCRIPT_DIR}"/test-eddsa.sh dsig-latency/dalek-reference dalek

DEPTH=2
for LOG_BATCH_SIZE in {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}; do
    BATCH_SIZE=$(( 2 ** $LOG_BATCH_SIZE ))
    "${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/latency/batchsize-of-$BATCH_SIZE haraka $LOG_BATCH_SIZE $DEPTH
    "${SCRIPT_DIR}"/test-cpu-tput.sh $FIGURE_NAME/cpu-tput/batchsize-of-$BATCH_SIZE $LOG_BATCH_SIZE $DEPTH
done

"${SCRIPT_DIR}"/unlimit-bandwidth.sh
