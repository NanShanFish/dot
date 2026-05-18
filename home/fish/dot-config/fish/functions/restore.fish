function restore
    set -q XDG_DATA_HOME; or set -l XDG_DATA_HOME "$HOME/.local/share"
    set -l trash_dir "$XDG_DATA_HOME/Trash"

    if not test -d "$trash_dir/info"
        echo "Trash is empty."
        return
    end

    # 1. 解析所有符合 XDG 规范的 .trashinfo 文件，提取原路径
    set -l fzf_input (
        for info_file in $trash_dir/info/*.trashinfo
            if test -f "$info_file"
                set -l tname (path basename "$info_file" | string replace -r '\.trashinfo$' '')
                # 正则匹配出 Path= 后面的完整原始路径
                set -l orig_path (string match -r '^Path=(.*)' (cat "$info_file"))[2]
                if test -n "$orig_path"
                    printf "%s\t%s\n" $orig_path $tname
                end
            end
        end
    )

    if test -z "$fzf_input"
        echo "Trash is empty."
        return
    end

    # 2. 调用 fzf 交互选择
    if test (count $argv) -eq 0
        set -l restore_fzf_opts "--delimiter=\t" "--with-nth=1" "--preview-window=50%" --preview="__restore_preview $trash_dir/files/{2}" "--multi" --scheme=path
        set -f selected (printf "%s\n" $fzf_input | _fzf_wrapper $restore_fzf_opts)
    else
        set -f selected (printf "%s\n" $fzf_input | grep -E "$argv")
    end

    set -l total (count $selected)
    if test $total -eq 0; return; end
    set -l cnt 0

    # 3. 还原操作
    for item in $selected
        set -l parts (string split \t -- $item)
        set -l orig_path $parts[1]
        set -l trash_name $parts[2]

        printf "\r%d/%d:%s" $cnt $total $orig_path >&2
        mkdir -p (path dirname "$orig_path")

        if test -e "$orig_path"
            echo -e "\nERROR: $orig_path exists" >&2
        else
            # 将 files/ 中的本体移回原位，并销毁 info/ 下的伴生文件
            if advmv -g --no-clobber "$trash_dir/files/$trash_name" "$orig_path"
                rm "$trash_dir/info/$trash_name.trashinfo"
                set cnt (math $cnt + 1)
            end
        end
    end
    printf "\r%d/%d restored\n" $cnt $total >&2
end
