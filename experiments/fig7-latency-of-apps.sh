#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# Otherwise, run the following to unlimit bandwidth:
# "${SCRIPT_DIR}"/unlimit-bandwidth.sh

FIGURE_NAME="fig7-latency-of-apps"

"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/herd-audit/no-crypto herd "16,32,80,90,10240" none
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/herd-audit/dsig herd "16,32,80,90,10240" dsig
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/herd-audit/eddsa-dalek herd "16,32,80,90,10240" dalek
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/herd-audit/eddsa-sodium herd "16,32,80,90,10240" sodium

"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/redis-audit/no-crypto redis "16,32,80,90,10240" none
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/redis-audit/dsig redis "16,32,80,90,10240" dsig
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/redis-audit/eddsa-dalek redis "16,32,80,90,10240" dalek
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/redis-audit/eddsa-sodium redis "16,32,80,90,10240" sodium

"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/liquibook-audit/no-crypto liquibook "50,10240" none
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/liquibook-audit/dsig liquibook "50,10240" dsig
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/liquibook-audit/eddsa-dalek liquibook "50,10240" dalek
"${SCRIPT_DIR}"/test-audit-app.sh $FIGURE_NAME/liquibook-audit/eddsa-sodium liquibook "50,10240" sodium

"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/ctb/no-crypto free
"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/ctb/dsig dsig --core 26
"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/ctb/eddsa-dalek dalek
"${SCRIPT_DIR}"/test-ubft-tcb.sh $FIGURE_NAME/ctb/eddsa-sodium sodium

"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/ubft/no-crypto free
"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/ubft/dsig dsig --core 26
"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/ubft/eddsa-dalek dalek
"${SCRIPT_DIR}"/test-ubft.sh $FIGURE_NAME/ubft/eddsa-sodium sodium
