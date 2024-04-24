#!/bin/bash
set -e

SCRIPT_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$SCRIPT_DIR"

for i in {1..4}; do
  ssh w$i "cd dsig-artifacts; rm -rf logs.zip; zip -r logs.zip logs/"
  scp w$i:~/dsig-artifacts/logs.zip w$i-logs.zip
  unzip -o w$i-logs.zip
done