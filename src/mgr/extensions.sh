extensions=$(ls "$extension_dir" \
  | grep '\.sh$' \
  | sed 's/\.sh$//' \
  | sort
)

source_extensions() {
  local extension
  for extension in $extensions; do
    source "${extension_dir}/${extension}.sh"
  done
}

extensions_run() {
  local prefix=$1
  local extension

  for extension in $extensions; do
    local command_name="${prefix}_${extension}"
    local available=$(command -v "$command_name")

    if [ -n "$available" ]; then
      "$command_name"
    fi
  done
}

extensions_load() {
  extensions_run "load"
}

extensions_pre_loop() {
  extensions_run "pre_loop"
}

extensions_post_loop() {
  extensions_run "post_loop"
}

extensions_command() {
  local content="$2"
  local command_prefix=$(echo "$1" | tail -c +2)
  local command_name="command_${command_prefix}"
  local available=$(command -v "$command_name")

  if [ -n "$available" ]; then
    "$command_name" "$content"
    return 0
  fi

  return 1
}

