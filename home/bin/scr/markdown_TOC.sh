#!/bin/bash

# 默认值
FSTR="%t"
INPUT_FILE=""
USE_STDIN=false
DIR="$(dirname "$0")"

# 显示帮助信息
show_help() {
    echo "用法: $0 [-f format] [文件]"
    echo "选项:"
    echo "  -f format    指定标题格式字符串 (默认: %t)"
    echo "               %t 会被替换为实际的标题内容"
    echo "示例:"
    echo "  $0 -f \"[[%t]]\" input.md      # 处理指定文件"
    echo "  cat input.md | $0 -f \"[[%t]]\" # 通过管道处理"
    echo "  $0 -f \"→ %t\" input.md        # 使用自定义格式"
}

# 解析命令行选项
while getopts "f:h" opt; do
    case $opt in
        f)
            FSTR="$OPTARG"
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            echo "错误: 无效选项 -$OPTARG" >&2
            show_help
            exit 1
            ;;
    esac
done

shift $((OPTIND -1))

# 检查输入源：管道或文件参数
if [ -t 0 ]; then
    # 没有管道输入，检查文件参数
    if [ $# -eq 0 ]; then
        echo "错误: 请指定输入文件或使用管道输入" >&2
        show_help
        exit 1
    else
        INPUT_FILE="$1"
        if [ ! -f "$INPUT_FILE" ]; then
            echo "错误: 文件不存在: $INPUT_FILE" >&2
            exit 1
        fi
        USE_STDIN=false
    fi
fi

# 设置文件名变量（用于显示）
if [ "$USE_STDIN" = true ]; then
    FNAME="stdin"
else
    FNAME="$(basename "$INPUT_FILE")"
fi

# 处理输入并应用格式化的awk脚本
process_input() {
    awk -v format_str="$FSTR" '
    BEGIN {
        in_codeblock = 0
    }
    /^```/ {
        in_codeblock = !in_codeblock
        next
    }
    /^#+ / && (in_codeblock == 0) {
        gsub(/# /, "#", $0)
        print $0
        next
    }
    '
}

# 执行处理
if [ "$USE_STDIN" = true ]; then
    process_input | "$DIR"/indent_tree.sh -c '#'
else
    process_input < "$INPUT_FILE" | "$DIR"/indent_tree.sh -c '#' -t "$FNAME"
fi
