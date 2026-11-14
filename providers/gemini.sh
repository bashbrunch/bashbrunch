#!/bin/bash

api_key=$1
model=$2
prompt=$3

url="https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${api_key}"

payload=$(jq -n --arg p "$prompt" '{
  contents: [
    {
      parts: [
        { text: $p }
      ]
    }
  ]
}')

response=$(curl -s -X POST "$url" \
  -H "Content-Type: application/json" \
  -d "$payload")

error=$(jq -r '.error' <<< "$response")

if [ -n "$error" ]; then
  error_message=$(jq -r '.error' <<< "$response")
  error_message=$(jq -r '.message' <<< "$error_message")

  echo "/msg Gemini Error: $error_message"
  echo "/pass"

  exit 0
fi

echo "$response" | jq -r '.candidates[0].content.parts[0].text // empty'

