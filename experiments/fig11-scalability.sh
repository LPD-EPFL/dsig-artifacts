#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Warning: This will reduce the bandwitdth of the network card to 10Gbps and can impact other experiments.
# It is thus important to remove the limit afterward if the script is interrupted.
"${SCRIPT_DIR}"/limit-bandwidth.sh

FIGURE_NAME="fig11-scalability"

for RUN in {1..3}; do
    for NB_CLIENTS in {12..1}; do
        $FOLDER_PREFIX = $FIGURE_NAME/scaling-verifiers/$NB_CLIENTS-verifiers
        "${SCRIPT_DIR}"/test-scalability-verifiers.sh $FOLDER_PREFIX/dsig/run$RUN dsig $NB_CLIENTS auto 0
        "${SCRIPT_DIR}"/test-scalability-verifiers.sh $FOLDER_PREFIX/eddsa-dalek/run$RUN dalek $NB_CLIENTS auto 0
        $FOLDER_PREFIX = $FIGURE_NAME/scaling-signers/$NB_CLIENTS-signers
        "${SCRIPT_DIR}"/test-scalability-signers.sh $FOLDER_PREFIX/dsig/run$RUN dsig $NB_CLIENTS auto 0
        "${SCRIPT_DIR}"/test-scalability-signers.sh $FOLDER_PREFIX/eddsa-dalek/run$RUN dalek $NB_CLIENTS auto 0 -t 60
    done
done

"${SCRIPT_DIR}"/unlimit-bandwidth.sh