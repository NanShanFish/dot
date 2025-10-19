#!/usr/bin/env bash

if [ -z "$1" ]; then
	file="$XDG_DOCUMENTS_DIR/notes/2-daily/Todo/todo.md"
else
	file=$1
fi

current_time_stamp=$(date +%s)

# 读取文件并处理每一行
while IFS= read -r line; do
	date_str=$(echo "$line" | grep -oP '\[scheduled:: \K\d{4}-\d{1,2}-\d{2}')
	if [ "$date_str" ]; then
		days_diff=$(( ($(date -d "$date_str" +%s) - $current_time_stamp) / 86400 ))
		txt="后"
		if [ $days_diff -lt 0 ]; then
			txt="前"
			days_diff=$(( $days_diff * -1 ))
		fi
		if [ $days_diff -lt 10 ]; then
			case "$days_diff$txt" in
				"0后") days_diff="  今 天" ;;
				"1后") days_diff="  明 天" ;;
				"2后") days_diff="  后 天" ;;
				"1前") days_diff="  昨 天" ;;
				"2前") days_diff="  前 天" ;;
				*) days_diff=" $days_diff 天$txt"
			esac
		elif [ $days_diff -lt 100 ]; then
			days_diff=" ${days_diff}天${txt}"
		else
			days_diff="${days_diff}天${txt}"
		fi

		echo "$line" | awk -v dat="$days_diff" '
		{
			if (substr($0, 4, 1) != " ")
				print "<span color=\"#ff79c6\"><s>"dat,$3,$4"</s></span>"
			else
				print dat,$4,$5
		}'
	fi
done < $file
