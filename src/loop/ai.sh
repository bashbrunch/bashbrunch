ai_loop() {
  get_ai_input
  read_ai_buffer

  local command=$(get_command "$ai_result")
  local content=$(get_content "$ai_result")
  local cmdtype=$(is_cmd_type "$command")

  add_chat "$model" "$ai_result"

  if [ "$cmdtype" -eq 0 ]; then
    add_chat "system" "Assistant's response was not a command."
    add_chat "system" "Response shall be ignored."
    add_chat "system" "Response will not be sent to the user."
    continue
  fi
  
  case "$command" in
    "/v")
      add_chat "system" $version
      println ""
      ;;
    "/sh")
      run_shell "$content"
      ;;
    "/dir")
      change_dir "$content"
      ;;
    "/msg")
      printf "$content"
      println "\n"
      ;;
    "/sh2a")
      ssf_append "$content"
      println "[[ SSF Appended ]]"
      ;;
    "/sh2r")
      ssf_read "$content"
      println "[[ SSF Read ]]"
      ;;
    "/sh2x")
      ssf_execute "$content"
      ;;
    "/sh2c")
      ssf_clear
      println "[[ SSF Cleared ]]"
      ;;
    "/pass")
      pass_control
      ;;
    "/exit")
      request_exit
      ;;
    *)
      extensions_command "$command" "$content"

      if [ $? -ne 0 ]; then
        add_chat "system" "Unknown command: $command"
        println "Unknown command: $command"
        println ""
      fi
      ;;
  esac
}

