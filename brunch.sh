#!/bin/bash

brunch_root="."
session_id="$(date +%s)-$RANDOM-$RANDOM"

if [ -n "$BRUNCH_ROOT" ]; then
  brunch_root="$BRUNCH_ROOT"
fi

source "$brunch_root/src/lib/colors.sh"
source "$brunch_root/src/lib/utils.sh"
source "$brunch_root/src/lib/inputs.sh"
source "$brunch_root/src/lib/cmd.sh"
source "$brunch_root/src/core/paths.sh"
source "$brunch_root/src/core/version.sh"
source "$brunch_root/src/core/arguments.sh"
source "$brunch_root/src/mgr/chat.sh"
source "$brunch_root/src/mgr/control.sh"
source "$brunch_root/src/mgr/extensions.sh"
source "$brunch_root/src/tool/shell.sh"
source "$brunch_root/src/tool/ssf.sh"
source "$brunch_root/src/loop/ai.sh"
source "$brunch_root/src/loop/user.sh"

source_extensions

println "BashBrunch $version"
println "Use /? for help"
println ""

println "Session ID: $session_id"
println "Active Provider: $provider"
println "Active Model: $model"
println ""

extensions_load

while [ true ]; do
  if [ "$requested_exit" -ne 0 ]; then
    break
  fi

  active=$(get_controller)
  extensions_pre_loop

  if [ "$active" = "user" ]; then
    use_color_user
    user_loop
  elif [ "$active" = "ai" ]; then
    use_color_ai
    ai_loop
  fi

  extensions_post_loop
done

if [ $requested_exit -eq 2 ]; then
  println "Exiting! (session closed by AI)"
else
  println "Exiting!"
fi

