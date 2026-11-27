ai_buffer=""
ai_result=""

get_context_prompt() {
  println "$chat_history"
  println "\nSystem Prompt:"
  println "$system_prompt"
}

get_ai_input() {
  buffer_pending=$(println "$ai_buffer" | wc -w | xargs)
  context_prompt=$(get_context_prompt)

  if [ "$buffer_pending" -eq 0 ]; then
    ai_buffer=$(bash $provider_file \
      "$api_key" \
      "$model" \
      "$context_prompt"
    )
  fi
}

read_ai_buffer() {
  line_count=$(println "$ai_buffer" | wc -l | xargs)
  line_count=$((line_count))
  checkpoint=$(println "$ai_buffer\n/pass" \
    | tail -n +2 \
    | grep -n '^/' \
    | grep -o '^[^:]*' \
    | head -n 1
  )

  if [ -z "$checkpoint" ]; then
    checkpoint=$line_count
  fi

  ai_result=$(println "$ai_buffer" | head -n $checkpoint)
  ai_buffer=$(println "$ai_buffer" | tail -n +$((checkpoint + 1)))
}

