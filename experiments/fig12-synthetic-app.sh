#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Warning: This will reduce the bandwitdth of the network card to 10Gbps and can impact other experiments.
# It is thus important to remove the limit afterward if the script is interrupted.
"${SCRIPT_DIR}"/limit-bandwidth.sh

FIGURE_NAME="fig12-synthetic-app"

for PROC_TIME in {1000,15000}; done
    for MSG_SIZE in {32,128,512,2048,8192,32768,131072}; do
        FOLDER_PREFIX=$FIGURE_NAME/${PROC_TIME}ns-processing-time/msgs-of-${MSG_SIZE}B
        "${SCRIPT_DIR}"/test-synthetic.sh $FOLDER_PREFIX/dsig dsig 3 $PROC_TIME $MSG_SIZE auto 0
        "${SCRIPT_DIR}"/test-synthetic.sh $FOLDER_PREFIX/eddsa-dalek dalek 4 $PROC_TIME $MSG_SIZE auto 0
        "${SCRIPT_DIR}"/test-synthetic.sh $FOLDER_PREFIX/no-crypto none 4 $PROC_TIME $MSG_SIZE auto 0
    done
done

"${SCRIPT_DIR}"/unlimit-bandwidth.sh
