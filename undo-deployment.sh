#!/bin/bash
set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$SCRIPT_DIR"

for i in {1..4}; do
  ssh w$i "delete -r dsig-artifacts"
done