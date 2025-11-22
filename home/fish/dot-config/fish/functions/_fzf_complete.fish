function _fzf_complete
    set -f completions (complete -C"" | string replace -r '\t.*' '')
    if test -z "$completions"
        commandline -f repaint
        return
    end
    if test (count $completions) -eq 1
        if string match --quiet -- "*/" $completions[1]
            commandline --current-token --replace -- $completions
        else
            commandline --current-token --replace -- $completions" "
        end
    else
        commandline --current-token --replace -- (printf '%s\n' $completions | _fzf_wrapper)
    end

    commandline -f repaint
end
