#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# Otherwise, run the following to unlimit bandwidth:
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig1-intro-latency-of-apps"

# Note: sodium is not enabled/shown as it is always worse than dalek. See fig7 for sodium results.

"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/auditable-kvs/no-crypto herd "16,32,80,90,10240" none
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/auditable-kvs/dsig herd "16,32,80,90,10240" dsig
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/auditable-kvs/eddsa-dalek herd "16,32,80,90,10240" dalek
# "${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/auditable-kvs/eddsa-sodium herd "16,32,80,90,10240" sodium

"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/bft-broadcast/no-crypto free
"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/bft-broadcast/dsig dsig --core 26
"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/bft-broadcast/eddsa-dalek dalek
# "${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/bft-broadcast/eddsa-sodium sodium

"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/bft-replication/no-crypto free
"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/bft-replication/dsig dsig --core 26
"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/bft-replication/eddsa-dalek dalek
# "${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/bft-replication/eddsa-sodium sodium
