function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l prompt_git (fish_vcs_prompt '%s')

    set_color brblack
    echo -n '-['
    set_color magenta
    echo -n (prompt_pwd)
    set_color brblack
    echo -n ']'

    if test -n "$prompt_git"
        echo -n '-['
        set_color green
        echo -n $prompt_git
        set_color brblack
        echo -n ']'
    end

    echo

    set_color normal
    for job in (jobs)
        set_color $retc
        echo -n '- '
        set_color brown
        echo $job
    end

    if test $last_status -eq 0
        set_color blue
    else
        set_color red
    end
    echo -n -s "% "
    set_color normal
end
