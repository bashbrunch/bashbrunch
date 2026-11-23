remote_url=$1
prompt=$3

source "$BRUNCH_ROOT/src/lib/remote.sh"
remote_push "prompts" "$prompt"
fetch_remote_data "proxies"

