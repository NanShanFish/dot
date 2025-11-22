function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    echo -n -s (set_color brblack) '-[' (set_color magenta) (prompt_pwd) (set_color brblack) ']'

    set -q __fish_git_prompt_showdirtystate
    or set -g __fish_git_prompt_showdirtystate 1
    set -q __fish_git_prompt_showuntrackedfiles
    or set -g __fish_git_prompt_showuntrackedfiles 1
    set -q __fish_git_prompt_showcolorhints
    or set -g __fish_git_prompt_showcolorhints 1
    set -q __fish_git_prompt_color_untrackedfiles
    or set -g __fish_git_prompt_color_untrackedfiles yellow
    set -q __fish_git_prompt_char_untrackedfiles
    or set -g __fish_git_prompt_char_untrackedfiles '?'
    set -q __fish_git_prompt_color_invalidstate
    or set -g __fish_git_prompt_color_invalidstate red
    set -q __fish_git_prompt_char_invalidstate
    or set -g __fish_git_prompt_char_invalidstate '!'
    set -q __fish_git_prompt_color_dirtystate
    or set -g __fish_git_prompt_color_dirtystate blue
    set -q __fish_git_prompt_char_dirtystate
    or set -g __fish_git_prompt_char_dirtystate '*'
    set -q __fish_git_prompt_char_stagedstate
    or set -g __fish_git_prompt_char_stagedstate '+'
    set -q __fish_git_prompt_color_cleanstate
    or set -g __fish_git_prompt_color_cleanstate green
    set -q __fish_git_prompt_char_cleanstate
    or set -g __fish_git_prompt_char_cleanstate '✓'
    set -q __fish_git_prompt_color_stagedstate
    or set -g __fish_git_prompt_color_stagedstate yellow
    set -q __fish_git_prompt_color_branch_dirty
    or set -g __fish_git_prompt_color_branch_dirty red
    set -q __fish_git_prompt_color_branch_staged
    or set -g __fish_git_prompt_color_branch_staged yellow
    set -q __fish_git_prompt_color_branch
    or set -g __fish_git_prompt_color_branch green
    set -q __fish_git_prompt_char_stateseparator
    or set -g __fish_git_prompt_char_stateseparator '⚡'
    set -l prompt_git (fish_vcs_prompt '%s')

    test -n "$prompt_git"
    and echo -n -s (set_color brblack) '-[' (set_color green)" " $prompt_git (set_color brblack) ']'
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
    echo -n -s "% " (set_color normal)
end
