function restore
    if test (count $argv) -eq 0
        set -f restore_fzf_opts "--delimiter=\t" "--with-nth=1" "--preview-window=50%" --preview="__restore_preview $TRASH/{2}" "--multi" --scheme=path
        set -f items (fd --base-directory="$TRASH" --max-depth=1 | awk '{ orig=$0; gsub(/%%/, "/", $0); print $0 "\t" orig }'| _fzf_wrapper $restore_fzf_opts)
    else
        set -f items (echo $argv | awk '{ orig=$0; gsub(/%%/, "/", $0); print $0 "\t" orig }')
    end
    set -f total (count $items)
    set -f cnt 0

    for item in $items
        set -l path_and_name (string split \t $item)
        set -l fpath (echo $path_and_name[1] | string sub -s 12)
        printf "\r%d/%d:%s" $cnt $total $fpath >&2
        mkdir -p (path dirname $fpath)
        if test -e $fpath
            echo -e "\nERROR: $fpath exists" >&2
        else
            mvg -g --no-clobber "$TRASH/$path_and_name[2]" $fpath
            set cnt (math $cnt + 1)
        end
    end
    printf "\r%d/%d" $cnt $total >&2
end
