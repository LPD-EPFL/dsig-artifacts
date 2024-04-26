#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

LIMIT=$3

echo -n "Running"
for i in $(seq 1 $LIMIT); do
  echo -n "."
  sleep 1
  "${SCRIPT_DIR}"/remote-invoker-completed.sh $1 $2
  if [ $? -eq 0 ]; then
    echo "  ✓"
    sleep .2
    exit 0
  fi
done
echo " × Unresponsive! ×"
sleep 1
exit 1