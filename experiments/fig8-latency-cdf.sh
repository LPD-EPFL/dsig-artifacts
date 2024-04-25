#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# Otherwise, run the following to unlimit bandwidth:
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig8-latency-cdf"

LOG_BATCH_SIZE=7
LOG_DEPTH=2
"${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/dsig haraka $LOG_BATCH_SIZE $LOG_DEPTH -r 128
"${SCRIPT_DIR}"/test-dsig-wots.sh $FIGURE_NAME/dsig-badhint haraka $LOG_BATCH_SIZE $LOG_DEPTH -S -r 128
"${SCRIPT_DIR}"/test-eddsa.sh $FIGURE_NAME/eddsa-dalek dalek
"${SCRIPT_DIR}"/test-eddsa.sh $FIGURE_NAME/eddsa-sodium sodium

# Note: the base network cost is estimated from half of EdDSA's round-trip time, and substracted in the graphs.