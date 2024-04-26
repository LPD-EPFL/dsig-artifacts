#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

# Use this to enforce the deactivation of bandwidth limiters.
# Bandwidth should be unlimited by default, that is:
# unless an experiment with limited bandwidth crashed or was interupted.
# But in case of doubts, run the following:
"${SCRIPT_DIR}"/unlimit-bandwidth.sh