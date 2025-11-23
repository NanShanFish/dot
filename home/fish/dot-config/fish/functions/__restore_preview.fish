function __restore_preview
    echo "Delete Time:" (stat -c %y $argv[1])
    echo "Content:"
    _fzf_preview_file $argv[1]
end
