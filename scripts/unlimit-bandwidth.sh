set -u

ibportstate -C mlx5_1 10 1 width 4 # 1x -> 4x
ibportstate -C mlx5_1 10 1 espeed 31 # enables > 10Gbps
ibportstate -C mlx5_1 10 1 reset

echo "Waiting 10 seconds for the port to reset..."
sleep 10

ibportstate -C mlx5_1 10 1
