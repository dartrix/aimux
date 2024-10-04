#!/bin/bash

# Capture the current pane's content and store it in a temporary file
tmux capture-pane -pS -32768 > /tmp/tmux_capture.txt

# Extract the last non-empty line from the captured content
current_input=$(grep -v '^$' /tmp/tmux_capture.txt | tail -n 1)
user_input=${current_input#*% }

# clear the console
tmux send-key C-u
tmux send-key "Thinking..."

prompt="you are an expert bash and script programmer and know all of the linux commands, that writes simple code. When someone ask you a question about how to do anything in the console, you just type the command that the need to run. Don't add quotes to the response. Response as if you are typing in the terminal.Please answer this question: ${user_input}"


response=$(curl http://localhost:11434/api/generate -d '{"model":"llama3.2","prompt": "'"${prompt}"'","stream": false}')

response_ai=$(echo "$response" | jq -r ".response")
# Output the current input
tmux send-key C-u
tmux send-keys "${response_ai}"
