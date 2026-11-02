request_remote_input() {
  if [ -z "$remote_url" ]; then
    return 1
  fi

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
    data=$(curl -fs "${remote_url}/message")
    key=""
    content=""

    if [ $? -eq 0 ]; then
      key=$(echo "$data" | head -n 1)
      content=$(echo "$data" | tail -n +2)
    fi

    if [ -n "$key" ]; then
      printf '%s\n' "$content"
      curl -s "${remote_url}/message/${key}" -X DELETE
      
      break
    fi

    interval=$((interval * 2))
    
    if [ $interval -gt 60 ]; then
      interval=60
    fi
  done
}

request_user_input() {
  local empty=""
  local prompt=""
  
  if [ -n "$remote_url" ]; then
    prompt=$(request_remote_input)
  else
    read -ep ">${empty}>${empty}> " prompt
    history -s "$prompt"
  fi
  
  printf '%s\n' "$prompt"
}

