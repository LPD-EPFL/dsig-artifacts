set -u

ibportstate -C mlx5_1 10 1 width 1 # 4x -> 1x
ibportstate -C mlx5_1 10 1 speed 7 # enables 10Gbps
ibportstate -C mlx5_1 10 1 espeed 30 # disables > 10Gbps
ibportstate -C mlx5_1 10 1 reset

echo "Waiting 10 seconds for the port to reset..."
sleep 10

ibportstate -C mlx5_1 10 1
