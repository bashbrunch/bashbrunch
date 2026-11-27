remote_push() {
  if [ -z "$remote_url" ]; then
    return 0
  fi

  endpoint=$1
  shift

  data=$(printf '%b\n' "$@")

  curl -s "${remote_url}/${endpoint}" \
    -H "Authorization: ${remote_pwd}" \
    -X POST \
    -d "$data" > /dev/null
}

get_remote_cursor() {
  local endpoint=$1
  local cursors_dir="${session_dir}/cursors"
  local cursor_path="${cursors_dir}/${endpoint}.txt"

  if [ ! -d "$cursors_dir" ]; then
    mkdir -p "$cursors_dir"
  fi

  if [ ! -f "$cursor_path" ]; then
    println "\n1" > "$cursor_path"
  fi

  cat "$cursor_path"
}

save_remote_cursor() {
  local endpoint=$1
  local cursor=$2
  local used=$3
  local cursors_dir="${session_dir}/cursors"
  local cursor_path="${cursors_dir}/${endpoint}.txt"

  if [ ! -d "$cursors_dir" ]; then
    mkdir -p "$cursors_dir"
  fi

  println "$cursor" > "$cursor_path"
  println "$used" >> "$cursor_path"
}

atomic_start() {
  local endpoint=$1
  local cursor_data=$(get_remote_cursor "$endpoint")
  local cursor_key=$(println "$cursor_data" | head -n 1)

  save_remote_cursor "$endpoint" "$cursor_key" 2
}

atomic_close() {
  local endpoint=$1
  local cursor_data=$(get_remote_cursor "$endpoint")
  local cursor_key=$(println "$cursor_data" | head -n 1)

  save_remote_cursor "$endpoint" "$cursor_key" 1
}

fetch_keys() {
  local data
  local endpoint=$1
  
  data=$(curl -fs "${remote_url}/${endpoint}/keys" \
    -H "Authorization: ${remote_pwd}")

  if [ $? -ne 0 ]; then
    return 1
  fi
  
  keys=$(println "$data" | grep -v "^$")
  printf "\n${keys}"
}

fetch_data() {
  local endpoint=$1
  local key=$2

  curl -fs "${remote_url}/${endpoint}/${key}" \
    -H "Authorization: ${remote_pwd}"

  if [ $? -eq 0 ]; then
    save_remote_cursor "$endpoint" "$cursor_key" 1
  fi
}

get_next_key() {
  curr=$1
  keys=$2

  if [ -z "$curr" ]; then
    println "$keys" \
      | grep -v "^$" \
      | head -n 1
    
    return 0
  fi
  
  println "$keys" \
    | grep -A 1 "$curr" \
    | grep -v "$curr" \
    | head -n 1
}

fetch_remote_data() {
  local endpoint=$1
  local atomic=$2

  if [ -z "$remote_url" ]; then
    return 1
  fi

  if [ -z "$atomic" ]; then
    atomic=0
  fi

  local skip_wait=1
  local interval=1

  local cursor_data=$(get_remote_cursor "$endpoint")
  local cursor_key=$(println "$cursor_data" | head -n 1)
  local cursor_used=$(println "$cursor_data" | head -n 2 | tail -n 1)

  while true; do
    if [ $skip_wait -eq 0 ]; then
      jitter=$((RANDOM % ((interval / 10) + 1)))
      sleep $((interval + jitter))
    fi

    skip_wait=0
    interval=$((interval * 2))
    
    if [[ $interval -gt $remote_max_wait ]]; then
      interval=$remote_max_wait
    fi

    if [[ "$cursor_used" -ne 1 ]]; then
      fetch_data "$endpoint" "$cursor_key"
      atomic_start "$endpoint"

      break
    fi

    local keys=$(fetch_keys "$endpoint")
    local key=$(get_next_key "$cursor_key" "$keys")
    get_next_key "$cursor_key" "$keys"

    if [ -z "$key" ]; then
      continue
    fi

    cursor_key="$key"
    cursor_used=0

    save_remote_cursor "$endpoint" "$cursor_key" 0
  done
}

