function mm
    set -q XDG_DATA_HOME; or set -l XDG_DATA_HOME "$HOME/.local/share"
    set -l trash_dir "$XDG_DATA_HOME/Trash"
    mkdir -p "$trash_dir/files" "$trash_dir/info"

    set -l total (count $argv)
    set -l cnt 0

    for f in $argv
        if test -e $f
            set -l rpath (realpath $f)
            set -l fname (path basename $rpath)

            set -l trash_name $fname
            set -l suffix 1
            while test -e "$trash_dir/files/$trash_name"
                set trash_name "$fname.$suffix"
                set suffix (math $suffix + 1)
            end

            printf "\r%d/%d:%s" $cnt $total $f >&2

            if advmv -g $f "$trash_dir/files/$trash_name"
                # 写入符合 XDG 规范的 .trashinfo 伴生文件
                printf "[Trash Info]\nPath=%s\nDeletionDate=%s\n" "$rpath" (date +%Y-%m-%dT%H:%M:%S) > "$trash_dir/info/$trash_name.trashinfo"
                set cnt (math $cnt + 1)
            end
        else
            set_color red; echo -e "\nERROR: $f not exists"; set_color normal
        end
    end
    printf "\r%d/%d\n" $cnt $total
end
