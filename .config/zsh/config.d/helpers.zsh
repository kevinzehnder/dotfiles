
function repeater() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: repeater <seconds> <command>"
    return 1
  fi

  local interval=$1
  shift
  local command="$@"

  while true; do
	echo "--- $(date +"%H:%M:%S") ---"  
    eval "$command"
    sleep $interval
  done}

