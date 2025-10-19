#!/usr/bin/env bash

use_color=true
use_html=false

while [ $# -gt 0 ]; do
    case "$1" in
        --no-color)
            use_color=false
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if [ "$use_color" = true ]; then
    source ./color.sh
else
    BLUE=""
    NORMAL=""
fi

current_date=$(date +%Y%m%d)
current_day_timestamp=$(date -d $current_date +%s)
current_year=${current_date:0:4}

while IFS= read -r line; do
    pattern="^- \[ \][ ]+📅 ([0-9]{4}-)?([0-9]{1,2}-[0-9]{1,2}( [0-9]{1,2}:[0-9]{2})?)[ ]+(.*?)[ ]+$"
	if [[ $line =~ $pattern ]]; then
        year="${BASH_REMATCH[1]}"
        if [ -z "$year" ]; then
            year="$current_year-"
        fi
        time="${BASH_REMATCH[3]}"
        if [ -z "$time" ]; then
            time=" 12:00"
        fi
        content="${BASH_REMATCH[4]}"
        date_str="$year${BASH_REMATCH[2]}$time"
		days_diff=$(( ($(date -d "$date_str" +%s) - $current_day_timestamp ) / 86400 ))
		txt="后"
		if [ $days_diff -lt 0 ]; then
			txt="前"
			days_diff=$(( $days_diff * -1 ))
		fi
		if [ $days_diff -lt 10 ]; then
			case "$days_diff$txt" in
				"0后") days_diff="今天" ;;
				"1后") days_diff="明天" ;;
				"2后") days_diff="后天" ;;
				"1前") days_diff="昨天" ;;
				"2前") days_diff="前天" ;;
				*) days_diff="$days_diff天$txt"
			esac
		elif [ $days_diff -lt 100 ]; then
			days_diff="${days_diff}天${txt}"
		else
			days_diff="${days_diff}天${txt}"
		fi

        echo -e "$BLUE$days_diff$time$NORMAL $content"
	fi
done
