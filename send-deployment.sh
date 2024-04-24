for i in {1..4}; do
  scp deployment.zip w$i:~
  ssh w$i "unzip -o deployment.zip"
done