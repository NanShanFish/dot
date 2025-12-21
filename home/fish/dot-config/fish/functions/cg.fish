function cg
    set -f git_root_dir (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_root_dir"
        cd "$git_root_dir"
    end
end
