request_user_input() {
  local empty=""
  local prompt=""
  
  if [ -n "$remote_url" ]; then
    prompt=$(fetch_remote_data "messages")
  else
    read -ep ">${empty}>${empty}> " prompt
  fi
  
  printf '%s\n' "$prompt"
}

