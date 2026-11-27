#!/bin/bash

api_key=$1
model=$2
prompt=$3

url="https://api.groq.com/openai/v1/chat/completions"

payload=$(jq -n --arg p "$prompt" --arg m "$model" '{
  model: $m,
  messages: [
    {
      role: "user",
      content: $p
    }
  ]
}')

response=$(curl -sS "$url" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $api_key" \
  -d "$payload")

error=$(jq -r '.error' <<< "$response")

if [ "$error" != "null" ]; then
  error_message=$(jq -r '.error' <<< "$response")
  error_message=$(jq -r '.message' <<< "$error_message")

  echo "/msg Groq Error: $error_message"
  echo "/pass"

  exit 0
fi

echo "$response" | jq -r '.choices[0].message.content // .error.message // empty'

