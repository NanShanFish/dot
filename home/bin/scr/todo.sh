#!/usr/bin/env bash

todolist=$(python ./get_todo.py)
notify-send "   TODO LIST" "\n$todolist" -r 9527 -t 20000 -i /dev/null
