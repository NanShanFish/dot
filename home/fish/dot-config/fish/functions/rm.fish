function rm
    set_color red
    echo "rm was forbidden, use mm instead" >&2
    set_color normal
    return 2
end
