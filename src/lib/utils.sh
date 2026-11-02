println() {
  printf '%b\n' "$@"
  data=$(printf '%b\n' "$@")

  if [ -n "$remote_url" ]; then
    curl -s "${remote_url}/shell" \
      -H "Authorization: Bearer ${remote_pwd}" \
      -X POST \
      -d "$data" > /dev/null
  fi
}

get_temp_name() {
  local timestamp=$(date +%s)
  local random_string="$RANDOM-$RANDOM"
  echo "${timestamp}_${random_string}"
}

