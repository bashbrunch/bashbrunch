println() {
  printf '%b\n' "$@"
  data=$(printf '%b\n' "$@")
}

remote_log() {
  if [ -z "$remote_url" ]; then
    return 0
  fi

  data=$(printf '%b\n' "$@")

  curl -s "${remote_url}/logs" \
    -H "Authorization: ${remote_pwd}" \
    -X POST \
    -d "$data" > /dev/null
}

get_temp_name() {
  local timestamp=$(date +%s)
  local random_string="$RANDOM-$RANDOM"
  echo "${timestamp}_${random_string}"
}

