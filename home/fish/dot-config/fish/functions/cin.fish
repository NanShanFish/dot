function cin
    if test "$XDG_SESSION_TYPE" = "wayland"
        wl-copy
    else
        xclip -selection clipboard -in
    end
end
