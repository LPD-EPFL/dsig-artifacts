#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# Otherwise, run the following to unlimit bandwidth:
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="table1-eddsa-vs-dsig"

LOG_DEPTH=2
LOG_BATCH_SIZE=7

"${SCRIPT_DIR}"/test-cpu-tput.sh $FIGURE_NAME/dsig-cpu-tput $LOG_BATCH_SIZE $LOG_DEPTH
"${SCRIPT_DIR}"/test-cpu-tput.sh $FIGURE_NAME/eddsa-dalek-cpu-tput $LOG_BATCH_SIZE $LOG_DEPTH --eddsa

"${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/dsig-latency haraka $LOG_BATCH_SIZE $LOG_DEPTH
"${SCRIPT_DIR}"/test-eddsa.sh $FIGURE_NAME/eddsa-dalek-latency dalek