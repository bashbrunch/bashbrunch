proxy_loop() {
  chat_history=$(fetch_remote_data "prompts")

  get_ai_input
  read_ai_buffer

  remote_push "proxies" "$ai_result"
  println "Remote Output: $ai_result"
}

