function _fzf_complete
    set -l token (commandline --current-token)
    set -l cmd (commandline -p)
    set -l completions (complete --do-complete --escape "$cmd" | string split -f1 \t)

    set -l num (count $completions)

    set -l selected
    if test $num -eq 0
        return
    else if test $num -eq 1
        set selected $completions[1]
    else
        set selected (printf "%s\n" $completions | _fzf_wrapper --query "$token" )
    end

    commandline --replace --current-token $selected
    commandline -f repaint
end
