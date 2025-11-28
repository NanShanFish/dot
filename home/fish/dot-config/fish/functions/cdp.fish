function cdp
    set -f cdp_fzf_opts --preview='_fzf_preview_file {}' --delimiter=/ --with-nth=4,5,6 --scheme=path
    if test -n $argv[1]
        set -f --append cdp_fzf_opts --query="$argv[1]"
    end
    set -f cdp_fd_opts --max-depth=2 --min-depth=2 -t d
    set -f path (fd $cdp_fd_opts --search-path=$HOME/proj --search-path=$HOME/prj | fzf $cdp_fzf_opts)
    if test -n "$path"
        cd $path
    end
end
