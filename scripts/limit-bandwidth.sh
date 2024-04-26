#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "${SCRIPT_DIR}"/config.sh

for i in $(seq 1 $MACHINE_COUNT); do
    MACHINE=$(machine2ssh machine$i)
    ssh -o LogLevel=QUIET -t $MACHINE \
        "ibportstate -C mlx5_1 10 1 width 1 # 4x -> 1x; \
         ibportstate -C mlx5_1 10 1 speed 7 # enables 10Gbps; \
         ibportstate -C mlx5_1 10 1 espeed 30 # disables > 10Gbps; \
         ibportstate -C mlx5_1 10 1 reset"
done

echo "Waiting 10 seconds for the ports to reset..."
sleep 10

for i in $(seq 1 $MACHINE_COUNT); do
    MACHINE=$(machine2ssh machine$i)
    ssh -t $MACHINE "ibportstate -C mlx5_1 10 1"
done
