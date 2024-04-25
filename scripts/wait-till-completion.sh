
set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

echo -n "Waiting for completion"
while true; do
  "${SCRIPT_DIR}"/remote-invoker-completed.sh $1 $2
  if [ $? -eq 0 ]; then
    break
  else
    echo -n "."
  fi
  sleep 1
done
sleep 1
echo " Finished."
