fetch_remote_data() {
  if [ -z "$remote_url" ]; then
    return 1
  fi

  local endpoint=$1
  local interval=1
  local wait=0
  local data=""
  local key=""
  local content=""

  while true; do
    if [ $wait != 0 ]; then
      sleep $interval
    fi
    
    wait=1
    key=""
    content=""
    data=$(curl -fs "${remote_url}/${endpoint}" \
      -H "Authorization: ${remote_pwd}"
    )

    if [ $? -eq 0 ]; then
      key=$(echo "$data" | head -n 1)
      content=$(echo "$data" | tail -n +2)
    fi

    if [ -n "$key" ]; then
      printf '%s\n' "$content"
      curl -s "${remote_url}/${endpoint}/${key}" \
        -H "Authorization: ${remote_pwd}" \
        -X DELETE > /dev/null
      
      break
    fi

    interval=$((interval * 2))
    
    if [ $interval -gt $remote_max_wait ]; then
      interval=$remote_max_wait
    fi
  done
}

